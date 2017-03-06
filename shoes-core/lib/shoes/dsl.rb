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

require 'shoes/dsl/animate'
require 'shoes/dsl/art'
require 'shoes/dsl/element'
require 'shoes/dsl/style'
require 'shoes/dsl/interaction'
require 'shoes/dsl/media'
require 'shoes/dsl/text'

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

    include DSL::Animate
    include DSL::Art
    include DSL::Element
    include DSL::Style
    include DSL::Interaction
    include DSL::Media
    include DSL::Text

    private

    def create(element, *args, &blk)
      element.new(@__app__, @__app__.current_slot, *args, &blk)
    end
  end
end

require 'shoes/internal_app'
require 'shoes/app'
require 'shoes/widget'
require 'shoes/url'
