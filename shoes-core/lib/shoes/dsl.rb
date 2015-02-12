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
require 'shoes/not_implemented_error'
require 'shoes/file_not_found_error'
require 'shoes/text_block_dimensions'

require 'shoes/color'

require 'shoes/common/background_element'
require 'shoes/common/changeable'
require 'shoes/common/clickable'
require 'shoes/common/initialization'
require 'shoes/common/positioning'
require 'shoes/common/remove'
require 'shoes/common/state'
require 'shoes/common/style'
require 'shoes/common/style_normalizer'
require 'shoes/common/visibility'

require 'shoes/common/ui_element'

require 'shoes/builtin_methods'
require 'shoes/check_button'
require 'shoes/text'
require 'shoes/span'
require 'shoes/input_box'

# please keep this list tidy and alphabetically sorted
require 'shoes/animation'
require 'shoes/arc'
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
require 'shoes/link_hover'
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
    include Common::Style
    include Color::DSLHelpers

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

    def image(path, styles = {}, &blk)
      create Shoes::Image, path, styles, blk
    end

    def border(color, styles = {})
      create Shoes::Border, pattern(color), styles
    end

    def background(color, styles = {})
      create Shoes::Background, pattern(color), style_normalizer.normalize(styles)
    end

    def edit_line(*args, &blk)
      style = pop_style(args)
      text  = args.first || ''
      create Shoes::EditLine, text, style, blk
    end

    def edit_box(*args, &blk)
      style = pop_style(args)
      text  = args.first || ''
      create Shoes::EditBox, text, style, blk
    end

    def progress(opts = {}, &blk)
      create Shoes::Progress, opts, blk
    end

    def check(opts = {}, &blk)
      create Shoes::Check, opts, blk
    end

    def radio(*args, &blk)
      style = pop_style(args)
      group = args.first
      create Shoes::Radio, group, style, blk
    end

    def list_box(opts = {}, &blk)
      create Shoes::ListBox, opts, blk
    end

    def flow(opts = {}, &blk)
      create Shoes::Flow, opts, blk
    end

    def stack(opts = {}, &blk)
      create Shoes::Stack, opts, blk
    end

    def button(text = nil, opts = {}, &blk)
      create Shoes::Button, text, opts, blk
    end

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

    # Creates an arc at (left, top)
    #
    # @param [Integer] left the x-coordinate of the top-left corner
    # @param [Integer] top the y-coordinate of the top-left corner
    # @param [Integer] width width of the arc's ellipse
    # @param [Integer] height height of the arc's ellipse
    # @param [Float] angle1 angle in radians marking the beginning of the arc segment
    # @param [Float] angle2 angle in radians marking the end of the arc segment
    # @param [Hash] opts Arc style options
    # @option opts [Boolean] wedge (false)
    # @option opts [Boolean] center (false) is (left, top) the center of the rectangle?
    def arc(left, top, width, height, angle1, angle2, styles = {}, &blk)
      create Shoes::Arc, left, top, width, height, angle1, angle2, styles, blk
    end

    # Draws a line from point A (x1,y1) to point B (x2,y2)
    #
    # @param [Integer] x1 The x-value of point A
    # @param [Integer] y1 The y-value of point A
    # @param [Integer] x2 The x-value of point B
    # @param [Integer] y2 The y-value of point B
    # @param [Hash] opts Style options
    def line(x1, y1, x2, y2, styles = {}, &blk)
      create Shoes::Line, Shoes::Point.new(x1, y1), Shoes::Point.new(x2, y2), styles, blk
    end

    # Creates an oval at (left, top)
    #
    # @overload oval(left, top, diameter)
    #   Creates a circle at (left, top), with the given diameter
    #   @param [Integer] left the x-coordinate of the top-left corner
    #   @param [Integer] top the y-coordinate of the top-left corner
    #   @param [Integer] diameter the diameter
    # @overload oval(left, top, width, height)
    #   Creates an oval at (left, top), with the given width and height
    #   @param [Integer] left the x-coordinate of the top-left corner
    #   @param [Integer] top the y-coordinate of the top-left corner
    #   @param [Integer] width the width
    #   @param [Integer] height the height
    # @overload oval(styles)
    #   Creates an oval using values from the styles Hash.
    #   @param [Hash] styles
    #   @option styles [Integer] left (0) the x-coordinate of the top-left corner
    #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
    #   @option styles [Integer] width (0) the width
    #   @option styles [Integer] height (0) the height
    #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
    #   @option styles [Boolean] center (false) is (left, top) the center of the oval
    OVAL_ALLOWED_ARG_SIZES = [0, 3, 4]
    def oval(*opts, &blk)
      oval_style = pop_style(opts)
      oval_style = style_normalizer.normalize(oval_style)

      left, top, width, height = opts

      message = <<EOS
Wrong number of arguments. Must be one of:
  - oval(left, top, diameter, [opts])
  - oval(left, top, width, height, [opts])
  - oval(styles)
EOS
      fail ArgumentError, message unless OVAL_ALLOWED_ARG_SIZES.include? opts.size
      create Shoes::Oval, left, top, width, height, oval_style, blk
    end

    # Creates a rectangle
    #
    # @overload rect(left, top, side, styles)
    #   Creates a square at (left, top), with sides of the given length
    #   @param [Integer] left the x-coordinate of the top-left corner
    #   @param [Integer] top the y-coordinate of the top-left corner
    #   @param [Integer] side the length of a side
    # @overload rect(left, top, width, height, rounded = 0, styles)
    #   Creates a rectangle at (left, top), with the given width and height
    #   @param [Integer] left the x-coordinate of the top-left corner
    #   @param [Integer] top the y-coordinate of the top-left corner
    #   @param [Integer] width the width
    #   @param [Integer] height the height
    # @overload rect(styles)
    #   Creates a rectangle using values from the styles Hash.
    #   @param [Hash] styles
    #   @option styles [Integer] left (0) the x-coordinate of the top-left corner
    #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
    #   @option styles [Integer] width (0) the width
    #   @option styles [Integer] height (0) the height
    #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
    #   @option styles [Boolean] center (false) is (left, top) the center of the rectangle?
    RECT_ALLOWED_ARG_SIZES = [0, 3, 4, 5]
    def rect(*args, &blk)
      opts = style_normalizer.normalize pop_style(args)

      left, top, width, height, curve = args
      opts[:curve] = curve if curve

      message = <<EOS
Wrong number of arguments. Must be one of:
  - rect(left, top, side, [opts])
  - rect(left, top, width, height, [opts])
  - rect(left, top, width, height, curve, [opts])
  - rect(styles)
EOS
      fail ArgumentError, message unless RECT_ALLOWED_ARG_SIZES.include? args.size
      create Shoes::Rect, left, top, width, height, style.merge(opts), blk
    end

    # Creates a new Shoes::Star object
    #
    # @overload star(left, top, styles, &block)
    #   Creates a star at (left, top) with the given style
    #   @param [Integer] left the x-coordinate of the top-left corner
    #   @param [Integer] top the y-coordinate of the top-left corner
    #   @param [Hash] styles optional, additional styling for the element
    # @overload star(left, top, points, styles, &block)
    #   Creates a star at (left, top) with the given style
    #   @param [Integer] left the x-coordinate of the top-left corner
    #   @param [Integer] top the y-coordinate of the top-left corner
    #   @param [Integer] points count of points on the star
    #   @param [Hash] styles optional, additional styling for the element
    # @overload star(left, top, points, outer, styles, &block)
    #   Creates a star at (left, top) with the given style
    #   @param [Integer] left the x-coordinate of the top-left corner
    #   @param [Integer] top the y-coordinate of the top-left corner
    #   @param [Integer] points count of points on the star
    #   @param [Integer] outer outer radius of star
    #   @param [Hash] styles optional, additional styling for the element
    # @overload star(left, top, points, outer, inner, styles, &block)
    #   Creates a star at (left, top) with the given style
    #   @param [Integer] left the x-coordinate of the top-left corner
    #   @param [Integer] top the y-coordinate of the top-left corner
    #   @param [Integer] points count of points on the star
    #   @param [Integer] outer outer radius of star
    #   @param [Integer] inner inner radius of star
    #   @param [Hash] styles optional, additional styling for the element
    def star(left, top, *args, &blk)
      styles = style_normalizer.normalize pop_style(args)

      points, outer, inner, extras = args

      if extras
        message = <<EOS
Wrong number of arguments. Must be one of:
  - star(left, top, [styles])
  - star(left, top, points, [styles])
  - star(left, top, points, outer, [styles])
  - star(left, top, points, outer, inner, [styles])
EOS
        fail ArgumentError, message
      end

      create Shoes::Star, left, top, points, outer, inner, styles, blk
    end

    # Creates a new Shoes::Shape object
    #
    # @overload shape(left, top, styles, &block)
    #   Creates a shape at (left, top) with the given style
    #   @param [Integer] left the x-coordinate of the top-left corner
    #   @param [Integer] top the y-coordinate of the top-left corner
    # @overload shape(left, top)
    #   Creates a shape at (left, top, &block)
    #   @param [Integer] left the x-coordinate of the top-left corner
    #   @param [Integer] top the y-coordinate of the top-left corner
    # @overload shape(styles, &block)
    #   Creates a shape at (0, 0)
    #   @option styles [Integer] left (0) the x-coordinate of the top-left corner
    #   @option styles [Integer] top (0) the y-coordinate of the top-left corner
    SHAPE_ALLOWED_ARG_SIZES = [0, 2]
    def shape(*args, &blk)
      opts = style_normalizer.normalize pop_style(args)
      opts[:left], opts[:top] = args if args.length == 2

      message = <<EOS
Wrong number of arguments. Must be one of:
  - shape()
  - shape(left, top, [opts])
  - shape(styles)
EOS
      fail ArgumentError, message unless SHAPE_ALLOWED_ARG_SIZES.include? args.length
      create Shoes::Shape, style.merge(opts), blk
    end

    # Define app-level setter methods
    PATTERN_APP_STYLES = [:fill, :stroke]
    OTHER_APP_STYLES = [:cap, :rotate, :strokewidth, :transform, :translate]

    PATTERN_APP_STYLES.each do |style|
      define_method style.to_s do |val|
        @__app__.style[style] = pattern(val)
      end
    end

    OTHER_APP_STYLES.each do |style|
      define_method style.to_s do |val|
        @__app__.style[style] = val
      end
    end

    def nostroke
      @__app__.style[:stroke] = nil
    end

    def nofill
      @__app__.style[:fill] = nil
    end

    %w(banner title subtitle tagline caption para inscription).each do |method|
      define_method method do |*texts|
        styles = pop_style(texts)
        klass = Shoes.const_get(method.capitalize)
        create klass, texts, styles
      end
    end

    TEXT_STYLES = {
      code: { font: "Lucida Console" },
      del: { strikethrough: true },
      em: { emphasis: true },
      ins: { underline: true },
      sub: { rise: -10, size_modifier: 0.8 },
      sup: { rise: 10, size_modifier: 0.8 },
      strong: { weight: true },
    }

    TEXT_STYLES.keys.each do |method|
      define_method method do |*texts|
        styles = style_normalizer.normalize(pop_style(texts))
        styles = TEXT_STYLES[method].merge(styles)
        Shoes::Span.new texts, styles
      end
    end

    def fg(*texts, color)
      Shoes::Span.new texts,  stroke: pattern(color)
    end

    def bg(*texts, color)
      Shoes::Span.new texts,  fill: pattern(color)
    end

    def link(*texts, &blk)
      opts = normalize_style_for_element(Shoes::Link, texts)
      Shoes::Link.new @__app__, texts, opts, blk
    end

    def span(*texts)
      opts = normalize_style_for_element(Shoes::Span, texts)
      Shoes::Span.new texts, opts
    end

    def mouse
      [@__app__.mouse_button, @__app__.mouse_pos[0], @__app__.mouse_pos[1]]
    end

    def motion(&blk)
      @__app__.mouse_motion << blk
    end

    def resize(&blk)
      @__app__.add_resize_callback blk
    end

    # hover and leave just delegate to the current slot as hover and leave
    # are just defined for slots but self is always the app.
    def hover(&blk)
      @__app__.current_slot.hover(blk)
    end

    def leave(&blk)
      @__app__.current_slot.leave(blk)
    end

    def keypress(&blk)
      Shoes::Keypress.new @__app__, &blk
    end

    def keyrelease(&blk)
      Shoes::Keyrelease.new @__app__, &blk
    end

    def append(&blk)
      blk.call if blk
    end

    def visit(url)
      match_data = nil
      url_data = Shoes::URL.urls.find { |page, _| match_data = page.match url }
      return unless url_data
      action_proc = url_data[1]
      url_argument = match_data[1]
      clear do
        @__app__.location = url
        action_proc.call self, url_argument
      end
    end

    def scroll_top
      @__app__.scroll_top
    end

    def scroll_top=(n)
      @__app__.scroll_top = n
    end

    def clipboard
      @__app__.clipboard
    end

    def clipboard=(str)
      @__app__.clipboard = str
    end

    def download(name, args = {}, &blk)
      create(Shoes::Download, name, args, &blk).tap(&:start)
    end

    def gutter
      @__app__.gutter
    end

    def video(*_args)
      fail Shoes::NotImplementedError,
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
