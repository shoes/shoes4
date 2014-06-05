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

    def image(path, opts={}, &blk)
      create Shoes::Image, path, opts, blk
    end

    def border(color, opts = {}, &blk)
      create Shoes::Border, pattern(color), opts, blk
    end

    def background(color, opts = {}, &blk)
      create Shoes::Background, pattern(color), style_normalizer.normalize(opts), blk
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
      create Shoes::Flow, opts, &blk
    end

    def stack(opts = {}, &blk)
      create Shoes::Stack, opts, &blk
    end

    def button(text, opts={}, &blk)
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
      opts = {:framerate => opts} unless opts.is_a? Hash
      Shoes::Animation.new @__app__, opts, blk
    end

    def every(n=1, &blk)
      animate 1.0/n, &blk
    end

    def timer(n=1, &blk)
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
    def arc(left, top, width, height, angle1, angle2, opts = {})
      create Shoes::Arc, left, top, width, height, angle1, angle2, opts
    end

    # Draws a line from point A (x1,y1) to point B (x2,y2)
    #
    # @param [Integer] x1 The x-value of point A
    # @param [Integer] y1 The y-value of point A
    # @param [Integer] x2 The x-value of point B
    # @param [Integer] y2 The y-value of point B
    # @param [Hash] opts Style options
    def line(x1, y1, x2, y2, opts = {})
      create Shoes::Line, Shoes::Point.new(x1, y1), Shoes::Point.new(x2, y2), style.merge(opts)
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
    def oval(*opts, &blk)
      oval_style = pop_style(opts)
      case opts.length
        when 3
          left, top, width = opts
          height = width
        when 4
          left, top, width, height = opts
        when 0
          left = oval_style[:left] || 0
          top = oval_style[:top] || 0
          width = oval_style[:diameter] || oval_style[:width] ||
                  (oval_style[:radius] || 0) * 2
          height = oval_style[:height] || width
        else
          message = <<EOS
Wrong number of arguments. Must be one of:
  - oval(left, top, diameter, [opts])
  - oval(left, top, width, height, [opts])
  - oval(styles)
EOS
          raise ArgumentError, message
      end
      create Shoes::Oval, left, top, width, height, oval_style, &blk
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
    def rect(*args, &blk)
      opts = style_normalizer.normalize pop_style(args)
      case args.length
      when 3
        left, top, width = args
        height = width
        opts[:curve] ||= 0
      when 4
        left, top, width, height = args
        opts[:curve] ||= 0
      when 5
        left, top, width, height, opts[:curve] = args
      when 0
        left = opts[:left] || 0
        top = opts[:top] || 0
        width = opts[:width] || 0
        height = opts[:height] || width
        opts[:curve] ||= 0
      else
        message = <<EOS
Wrong number of arguments. Must be one of:
  - rect(left, top, side, [opts])
  - rect(left, top, width, height, [opts])
  - rect(left, top, width, height, curve, [opts])
  - rect(styles)
EOS
        raise ArgumentError, message
      end
      create Shoes::Rect, left, top, width, height, style.merge(opts), &blk
    end

    def star(left, top, points = 10, outer = 100.0, inner = 50.0, opts = {}, &blk)
      opts = style_normalizer.normalize opts
      create Shoes::Star, left, top, points, outer, inner, opts, &blk
    end

    # Creates a new Shoes::Shape object
    def shape(shape_style = {}, &blk)
      create Shoes::Shape, style.merge(shape_style), blk
    end

    # Define app-level setter methods
    PATTERN_APP_STYLES = [:fill, :stroke]
    OTHER_APP_STYLES = [:cap, :strokewidth]

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

    # Text blocks
    # normally constants belong to the top, I put them here because they are
    # only used here.
    FONT_SIZES = {
      banner:       48,
      title:        34,
      subtitle:     26,
      tagline:      18,
      caption:      14,
      para:         12,
      inscription:  10
    }.freeze

    %w[banner title subtitle tagline caption para inscription].each do |method|
      define_method method do |*texts|
        opts = texts.last.class == Hash ? texts.pop : {}
        klass = Shoes.const_get(method.capitalize)
        create klass, texts, FONT_SIZES[method.to_sym], style_for_element(klass, opts)
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
        style = style_normalizer.normalize(pop_style(texts))
        opts = TEXT_STYLES[method].merge(style)
        Shoes::Span.new texts, opts
      end
    end

    def fg(*texts, color)
      Shoes::Span.new texts, { stroke: pattern(color) }
    end

    def bg(*texts, color)
      Shoes::Span.new texts, { fill: pattern(color) }
    end

    def link(*texts, &blk)
      opts = normalize_style_for_element(Shoes::Link, texts)
      create Shoes::Link, texts, opts, &blk
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
      url_data = Shoes::URL.urls.find {|page, _| match_data = page.match url}
      if url_data
        action_proc = url_data[1]
        url_argument = match_data[1]
        clear do
          @__app__.location = url
          action_proc.call self, url_argument
        end
      end
      timer(0.01) { @__app__.top_slot.contents_alignment }
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

    def download(name, args={}, &blk)
      create Shoes::Download, name, args, &blk
    end

    def gutter
      @__app__.gutter
    end
  end
end
