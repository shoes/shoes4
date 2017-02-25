# frozen_string_literal: true
require 'delegate'
require 'fileutils'
require 'forwardable'
require 'pathname'
require 'tmpdir'
require 'shoes/common/registration'

class Shoes
  PI                  = Math::PI
  TWO_PI              = 2 * PI
  HALF_PI             = 0.5 * PI
  DIR                 = Pathname.new(__FILE__).parent.parent.parent.to_s
  LOG                 = []
  LEFT_MOUSE_BUTTON   = 1
  MIDDLE_MOUSE_BUTTON = 2
  RIGHT_MOUSE_BUTTON  = 3

  extend Common::Registration

  class << self
    def logger
      Shoes.configuration.logger_instance
    end

    # To ease the upgrade path from Shoes 3 we warn users they need to install
    # and require gems themselves.
    #
    # @example
    #   Shoes.setup do
    #     gem 'bluecloth =2.0.6'
    #     gem 'metaid'
    #   end
    #
    # @param block [Proc] The block that describes the gems that are needed
    # @deprecated
    def setup(&block)
      $stderr.puts "WARN: The Shoes.setup method is deprecated, you need to install gems yourself." \
                   "You can do this using the 'gem install' command or bundler and a Gemfile."
      DeprecatedShoesGemSetup.new.instance_eval(&block)
    end

    # Load the backend in memory. This does not set any configuration.
    #
    # @param name [String|Symbol] The name, such as :swt or :mock
    # @return The backend
    def load_backend(name)
      require "shoes/#{name.to_s.downcase}"
      Shoes.const_get(name.to_s.capitalize)
    rescue LoadError => e
      raise LoadError, "Couldn't load backend Shoes::#{name.capitalize}'. Error: #{e.message}\n#{e.backtrace.join("\n")}"
    end
  end

  class DeprecatedShoesGemSetup
    def gem(name)
      name, version = name.split
      install_cmd = 'gem install ' + name
      install_cmd += " --version \"#{version}\"" if version
      $stderr.puts "WARN: To use the '#{name}' gem, install it with '#{install_cmd}', and put 'require \"#{name}\"' at the top of your Shoes program."
    end
  end
end

require 'shoes/core/version'
require 'shoes/packager'

require 'shoes/renamed_delegate'
require 'shoes/common/inspect'
require 'shoes/dimension'
require 'shoes/dimensions'
require 'shoes/file_not_found_error'
require 'shoes/http_request'
require 'shoes/not_implemented_error'
require 'shoes/text_block_dimensions'

require 'shoes/color'

require 'shoes/dsl/text'
require 'shoes/dsl/interaction'
require 'shoes/dsl/art'
require 'shoes/dsl/element'

require 'shoes/common/attachable'
require 'shoes/common/changeable'
require 'shoes/common/clickable'
require 'shoes/common/fill'
require 'shoes/common/hover'
require 'shoes/common/link_finder'
require 'shoes/common/positioning'
require 'shoes/common/remove'
require 'shoes/common/rotate'
require 'shoes/common/state'
require 'shoes/common/stroke'
require 'shoes/common/style'
require 'shoes/common/style_normalizer'
require 'shoes/common/translate'
require 'shoes/common/visibility'

require 'shoes/common/ui_element'
require 'shoes/common/art_element'
require 'shoes/common/background_element'

require 'shoes/builtin_methods'
require 'shoes/check_button'
require 'shoes/text'
require 'shoes/span'
require 'shoes/input_box'

# please keep this list tidy and alphabetically sorted
require 'shoes/animation'
require 'shoes/arc'
require 'shoes/arrow'
require 'shoes/background'
require 'shoes/border'
require 'shoes/button'
require 'shoes/configuration'
require 'shoes/color'
require 'shoes/dialog'
require 'shoes/download'
require 'shoes/font'
require 'shoes/gradient'
require 'shoes/image'
require 'shoes/image_pattern'
require 'shoes/key_event'
require 'shoes/line'
require 'shoes/link'
require 'shoes/list_box'
require 'shoes/logger'
require 'shoes/oval'
require 'shoes/point'
require 'shoes/progress'
require 'shoes/radio'
require 'shoes/rect'
require 'shoes/shape'
require 'shoes/slot_contents'
require 'shoes/slot'
require 'shoes/star'
require 'shoes/sound'
require 'shoes/text_block'
require 'shoes/timer'
require 'shoes/window'

class Shoes
  # Methods for creating and manipulating Shoes elements
  #
  # Requirements
  #
  # Including classes must provide:
  #
  #   @__app__
  #
  #   which provides
  #     #style:          a hash of styles
  #     #element_styles: a hash of {Class => styles}, where styles is
  #                      a hash of default styles for elements of Class,
  module DSL
    include Color::DSLHelpers
    include DSL::Text
    include DSL::Interaction
    include DSL::Art
    include DSL::Element
    # Set default style for elements of a particular class, or for all
    # elements, or return the current defaults for all elements
    #
    # @overload style(klass, styles)
    #   Set default style for elements of a particular class
    #   @param [Class] klass a Shoes element class
    #   @param [Hash] styles default styles for elements of klass
    #   @example
    #     style Para, :text_size => 42, :stroke => green
    #
    # @overload style(styles)
    # Set default style for all elements
    #   @param [Hash] styles default style for all elements
    #   @example
    #     style :stroke => alicewhite, :fill => black
    #
    # @overload style()
    #   @return [Hash] the default style for all elements
    def style(klass_or_styles = nil, styles = {})
      if klass_or_styles.kind_of? Class
        klass = klass_or_styles
        @__app__.element_styles[klass] = styles
      else
        @__app__.style(klass_or_styles)
      end
    end

    private

    def style_normalizer
      @style_normalizer ||= Common::StyleNormalizer.new
    end

    def pop_style(opts)
      opts.last.class == Hash ? opts.pop : {}
    end

    # Default styles for elements of klass
    def style_for_element(klass, styles = {})
      @__app__.element_styles.fetch(klass, {}).merge(styles)
    end

    def normalize_style_for_element(clazz, texts)
      style = style_normalizer.normalize(pop_style(texts))
      style_for_element(clazz, style)
    end

    def create(element, *args, &blk)
      element.new(@__app__, @__app__.current_slot, *args, &blk)
    end

    public

    # Creates an animation that runs the given block of code.
    #
    # @overload animate &blk
    #   @param [Proc] blk Code to run for each animation frame
    #   @return [Shoes::Animation]
    #   Defaults to framerate of 24 frames per second
    #   @example
    #     # 24 frames per second
    #     animate do
    #       # animation code
    #     end
    # @overload animate(framerate, &blk)
    #   @param [Integer] framerate Frames per second
    #   @param [Proc] blk Code to run for each animation frame
    #   @return [Shoes::Animation]
    #   @example
    #     # 10 frames per second
    #     animate 10 do
    #       # animation code
    #     end
    # @overload animate(opts = {}, &blk)
    #   @param [Hash] opts Animation options
    #   @param [Proc] blk Code to run for each animation frame
    #   @option opts [Integer] :framerate Frames per second
    #   @return [Shoes::Animation]
    #   @example
    #     # 10 frames per second
    #     animate :framerate => 10 do
    #       # animation code
    #     end
    #
    def animate(opts = {}, &blk)
      opts = { framerate: opts } unless opts.is_a? Hash
      Shoes::Animation.new @__app__, opts, blk
    end

    def every(n = 1, &blk)
      animate 1.0 / n, &blk
    end

    def timer(n = 1, &blk)
      n *= 1000
      Timer.new @__app__, n, &blk
    end

    # similar controls as Shoes::Video (#video)
    def sound(soundfile, opts = {}, &blk)
      Shoes::Sound.new @__app__, soundfile, opts, &blk
    end

    # Define app-level setter methods
    PATTERN_APP_STYLES = [:fill, :stroke].freeze
    OTHER_APP_STYLES = [:cap, :rotate, :strokewidth, :transform].freeze

    PATTERN_APP_STYLES.each do |style|
      define_method style do |val|
        @__app__.style[style] = pattern(val)
      end
    end

    OTHER_APP_STYLES.each do |style|
      define_method style do |val|
        @__app__.style[style] = val
      end
    end

    def translate(left, top)
      @__app__.style[:translate] = [left, top]
    end

    def nostroke
      @__app__.style[:stroke] = nil
    end

    def nofill
      @__app__.style[:fill] = nil
    end

    def video(*_args)
      raise Shoes::NotImplementedError,
            'Sorry video support has been cut from shoes 4!' \
            ' Check out github issue #113 for any changes/updates or if you' \
            ' want to help :)'
    end
  end
end

require 'shoes/internal_app'
require 'shoes/app'
require 'shoes/widget'
require 'shoes/url'
