require 'shoes/animation'
require 'shoes/background'
require 'shoes/border'
require 'shoes/button'
require 'shoes/color'
require 'shoes/edit_line'
require 'shoes/image'
require 'shoes/line'
require 'shoes/list_box'
require 'shoes/oval'
require 'shoes/progress'
require 'shoes/radio'
require 'shoes/shape'
require 'shoes/slot'
require 'shoes/sound'
require 'shoes/text'
require 'shoes/text_block'

module Shoes
  # Methods for creating and manipulating Shoes elements
  #
  # Requirements
  #
  # Including classes must provide:
  #
  #     @style - a hash of styles
  module DSL

    def color(c)
      Shoes::Color.create c
    end

    def pattern(*args)
      if args.length == 1
        arg = args.first
        case arg
        when String
          File.exist?(arg) ? image_pattern(arg) : color(arg)
        when Shoes::Color
          color(arg)
        when Range, Shoes::Gradient
          gradient(arg)
        else
          raise ArgumentError, "Bad pattern: #{arg.inspect}"
        end
      else
        gradient(*args)
      end
    end

    private

    def pop_style(opts)
      opts.last.class == Hash ? opts.pop : {}
    end

    def normalize_style(orig_style)
      normalized_style = {app: app}
      [:fill, :stroke].each do |s|
        normalized_style[s] = pattern(orig_style[s]) if orig_style[s]
      end
      orig_style.merge(normalized_style)
    end

    def create(element, *args)
      element.new( @app, current_slot, *args )
    end

    public

    # TODO
    # Shoes 3 also has `image width, height` that takes
    # a block with drawing instructions.
    def image(path, opts={}, &blk)
      create Shoes::Image, path, opts, blk
    end

    def border(color, opts = {}, &blk)
      create Shoes::Border, pattern(color), opts, blk
    end

    def background(color, opts = {}, &blk)
      create Shoes::Background, pattern(color), normalize_style(opts), blk
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

    def check(&blk)
      create Shoes::Check, blk
    end

    def radio(opts = {}, &blk)
      create Shoes::Radio, opts, blk
    end

    def list_box(opts = {}, &blk)
      create Shoes::ListBox, opts, blk
    end

    def flow(opts = {}, &blk)
      opts.merge! :app => app
      Shoes::Flow.new current_slot, opts, &blk
    end

    def stack(opts = {}, &blk)
      opts.merge! :app => @app
      Shoes::Stack.new current_slot, opts, &blk
    end

    def button(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Button.new current_slot, text, opts, blk
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
      opts.merge! :app => @app
      Shoes::Animation.new opts, blk
    end

    def every n=1, &blk
      animate 1.0/n, &blk
    end

    def timer n=1, &blk
      n *= 1000
      Timer.new @app, n, &blk
    end

    # similar controls as Shoes::Video (#video)
    def sound(soundfile, opts = {}, &blk)
      Shoes::Sound.new self.gui, soundfile, opts, &blk
    end

    # Draws an arc
    def arc(left, top, width, height, angle1, angle2, opts = {})
      Shoes::Arc.new(app, left, top, width, height, angle1, angle2, style.merge(opts))
    end

    # Draws a line from point A (x1,y1) to point B (x2,y2)
    #
    # @param [Integer] x1 The x-value of point A
    # @param [Integer] y1 The y-value of point A
    # @param [Integer] x2 The x-value of point B
    # @param [Integer] y2 The y-value of point B
    # @param [Hash] opts Style options
    def line(x1, y1, x2, y2, opts = {})
      Shoes::Line.new app, Shoes::Point.new(x1, y1), Shoes::Point.new(x2, y2), style.merge(opts)
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
      oval_style = normalize_style pop_style(opts)
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
      if oval_style[:center]
        left -= width / 2 if width > 0
        top -= height / 2 if height > 0
      end
      Shoes::Oval.new(app, left, top, width, height, style.merge(oval_style), &blk)
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
      opts = normalize_style pop_style(args)
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
      Shoes::Rect.new app, left, top, width, height, style.merge(opts), &blk
    end

    # Creates a new Shoes::Star object
    def star(*args, &blk)
      opts = normalize_style pop_style(args)
      case args.length
      when 2
        left, top = args
        points, outer, inner = 10, 100.0, 50.0
      when 5
        left, top, points, outer, inner = args
      else
        message = <<EOS
Wrong number of arguments. Must be one of:
  - star(left, top, [opts])
  - star(left, top, points, outer, inner, [opts])
EOS
        raise ArgumentError, message
      end
      Shoes::Star.new(app, left, top, points, outer, inner, opts, &blk)
    end

    # Creates a new Shoes::Shape object
    def shape(shape_style = {}, &blk)
      Shoes::Shape.new(app, style.merge(shape_style), blk)
    end

    # Creates a new Shoes::Color object
    def rgb(red, green, blue, alpha = Shoes::Color::OPAQUE)
      Shoes::Color.new(red, green, blue, alpha)
    end

    # Creates a new Shoes::Gradient
    #
    # @overload gradient(from, to)
    #   @param [Shoes::Color] from the starting color
    #   @param [Shoes::Color] to the ending color
    #
    # @overload gradient(from, to)
    #   @param [String] from a hex string representing the starting color
    #   @param [String] to a hex string representing the ending color
    #
    # @overload gradient(range)
    #   @param [Range<Shoes::Color>] range min color to max color
    #
    # @overload gradient(range)
    #   @param [Range<String>] range min color to max color
    def gradient(*args)
      case args.length
      when 1
        arg = args[0]
        case arg
        when Gradient
          min, max = arg.color1, arg.color2
        when Range
          min, max = arg.first, arg.last
        else
          raise ArgumentError, "Can't make gradient out of #{arg.inspect}"
        end
      when 2
        min, max = args[0], args[1]
      else
        raise ArgumentError, "Wrong number of arguments (#{args.length} for 1 or 2)"
      end
      Shoes::Gradient.new(color(min), color(max))
    end

    def image_pattern path
      Shoes::ImagePattern.new path
    end

    # Sets the current stroke color
    #
    # Arguments
    #
    # color - a Shoes::Color
    def stroke(color)
      @style[:stroke] = pattern(color)
    end

    def nostroke
      @style[:stroke] = nil
    end

    # Sets the stroke width, in pixels
    def strokewidth(width)
      @style[:strokewidth] = width
    end

    # Sets the current fill color
    #
    # @param [Shoes::Color,Shoes::Gradient] pattern the pattern to set as fill
    def fill(pattern)
      @style[:fill] = pattern(pattern)
    end

    def nofill
      @style[:fill] = nil
    end

    # Sets the current line cap style
    def cap line_cap
      @style[:cap] = line_cap
    end

    # Adds style, or just returns current style if no argument
    #
    # Returns the updated style
    def style(new_styles = {})
      @style.merge! new_styles
    end

    # Text blocks
    # normally constants belong to the top, I put them here because they are
    # only used here.
    BANNER_FONT_SIZE      = 48
    TITLE_FONT_SIZE       = 34
    SUBTITLE_FONT_SIZE    = 26
    TAGLINE_FONT_SIZE     = 18
    CAPTION_FONT_SIZE     = 14
    PARA_FONT_SIZE        = 12
    INSCRIPTION_FONT_SIZE = 10

    %w[banner title subtitle tagline caption para inscription].each do |m|
      define_method m do |*text|
        opts = text.last.class == Hash ? text.pop : {}
        styles = get_styles text
        opts[:text_styles] = styles unless styles.empty?
        text = text.map(&:to_s).join
        opts.merge! app: @app
        eval "Shoes::#{m.capitalize}.new(current_slot, text, #{m.upcase}_FONT_SIZE, opts)"
      end
    end

    def get_styles msg, styles=[], spoint=0
      msg.each do |e|
        if e.is_a? Shoes::Text
          epoint = spoint + e.to_s.length - 1
          styles << [e, spoint..epoint]
          get_styles e.str, styles, spoint
        end
        spoint += e.to_s.length
      end
      styles
    end

    [:code, :del, :em, :ins, :strong, :sub, :sup].each do |m|
      define_method m do |*str|
        Shoes::Text.new m, str
      end
    end

    [:bg, :fg].each do |m|
      define_method m do |*str|
        color = str.pop
        Shoes::Text.new m, str, pattern(color)
      end
    end

    def link *str, &blk
      Shoes::Link.new :link, str, &blk
    end

    def mouse
      [@app.mouse_button, @app.mouse_pos[0], @app.mouse_pos[1]]
    end

    def motion &blk
      @app.mouse_motion << blk
    end

    def hover &blk
      @hover_proc = blk
      (@app.mhcs << self) unless @app.mhcs.include? self
    end

    def leave &blk
      @leave_proc = blk
      (@app.mhcs << self) unless @app.mhcs.include? self
    end

    attr_reader :hover_proc, :leave_proc
    attr_accessor :hovered

    def keypress &blk
      opts = {:app => @app}
      Shoes::Keypress.new opts, &blk
    end

    def clear
      contents = @contents.dup
      contents.each do |e|
        e.is_a?(Shoes::Slot) ? e.clear : e.remove
      end
      @contents.clear
    end

    def visit url
      $urls.each{|k, v| clear{@location = url; v.call self, $1} if k =~ url}
    end

    def scroll_top
      @app.gui.scroll_top
    end

    def scroll_top=(n)
      @app.gui.scroll_top = n
    end

    def clipboard
      @app.gui.clipboard
    end

    def clipboard=(str)
      @app.gui.clipboard = str
    end

    def download name, args={}, &blk
      Shoes::Download.new @app, name, args, &blk
    end
  end
end
