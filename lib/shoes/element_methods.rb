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
require 'shoes/text_block'

module Shoes
  # Methods for creating and manipulating Shoes elements
  #
  # Requirements
  #
  # Including classes must provide:
  #
  #     @style - a hash of styles
  module ElementMethods

    #def stack(opts={}, &blk)
    #  tstack = Stack.new(opts)
    #  layout(tstack, &blk)
    #end

    def image(path, opts={}, &blk)
      opts.merge! app: @app
      Shoes::Image.new self, path, opts, blk
    end

    def border(color, opts = {}, &blk)
      opts.merge! app: @app
      Shoes::Border.new self, color, opts, blk
    end

    def background(color, opts = {}, &blk)
      opts.merge! :app => @app
      Shoes::Background.new self, color, opts, blk
    end

    def edit_line(opts = {}, &blk)
      opts.merge! :app => @app
      Shoes::EditLine.new self, opts, blk
    end

    def edit_box(opts = {}, &blk)
      opts.merge! :app => @app
      Shoes::EditBox.new self, opts, blk
    end

    def progress(opts = {}, &blk)
      opts.merge! :app => @app
      Shoes::Progress.new self, opts, blk
    end

    def check(opts = {}, &blk)
      opts.merge! :app => @app
      Shoes::Check.new self, opts, blk
    end

    def radio(opts = {}, &blk)
      opts.merge! :app => @app
      Shoes::Radio.new self, opts, blk
    end

    def list_box(opts = {}, &blk)
      opts.merge! :app => @app
      Shoes::ListBox.new self, opts, blk
    end

    def flow(opts = {}, &blk)
      opts.merge! :app => app
      Shoes::Flow.new self, opts, &blk
    end

    def stack(opts = {}, &blk)
      opts.merge! :app => @app
      Shoes::Stack.new self, opts, &blk
    end

    def button(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Button.new self, text, opts, blk
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
      oval_style = opts.last.class == Hash ? opts.pop : {}
      case opts.length
        when 3
          left, top, diameter = opts
          width = height = diameter
        when 4
          left, top, width, height = opts
        when 0
          left = oval_style[:left] || 0
          top = oval_style[:top] || 0
          width = oval_style[:width] || 0
          height = oval_style[:height] || 0
          radius = oval_style[:diameter] || 0
          width = oval_style[:diameter] if width.zero?
          height = width if height.zero?
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
      opts = args.last.class == Hash ? args.pop : {}
      case args.length
      when 3
        left, top, width = args
        height = width
        opts[:corners] = 0
      when 4
        left, top, width, height = args
        opts[:corners] = 0
      when 5
        left, top, width, height, opts[:corners] = args
      when 0
        left = opts[:left] || 0
        top = opts[:top] || 0
        width = opts[:width] || 0
        height = opts[:height] || width
        opts[:corners] ||= 0
      else
        message = <<EOS
Wrong number of arguments. Must be one of:
  - rect(left, top, side, [opts])
  - rect(left, top, width, height, [opts])
  - rect(left, top, width, height, corners, [opts])
  - rect(styles)
EOS
        raise ArgumentError, message
      end
      Shoes::Rect.new app, left, top, width, height, style.merge(opts), &blk
    end

    # Creates a new Shoes::Shape object
    def shape(shape_style = {}, &blk)
      Shoes::Shape.new(app, style.merge(shape_style), blk)
    end

    # Creates a new Shoes::Color object
    def rgb(red, green, blue, alpha = Shoes::Color::OPAQUE)
      Shoes::Color.new(red, green, blue, alpha)
    end

    # Sets the current stroke color
    #
    # Arguments
    #
    # color - a Shoes::Color
    def stroke(color)
      @style[:stroke] = color
    end

    # Sets the stroke width, in pixels
    def strokewidth(width)
      @style[:strokewidth] = width
    end

    # Sets the current fill color
    #
    # Arguments
    #
    # color - a Shoes::Color
    def fill(color)
      @style[:fill] = color
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

    def banner(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Banner.new(self, text, BANNER_FONT_SIZE, opts)
    end

    def title(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Title.new(self, text, TITLE_FONT_SIZE, opts)
    end

    def subtitle(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Subtitle.new(self, text, SUBTITLE_FONT_SIZE, opts)
    end

    def tagline(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Tagline.new(self, text, TAGLINE_FONT_SIZE, opts)
    end

    def caption(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Caption.new(self, text, CAPTION_FONT_SIZE, opts)
    end

    def para(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Para.new(self, text, PARA_FONT_SIZE, opts)
    end

    def inscription(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Inscription.new(self, text, INSCRIPTION_FONT_SIZE, opts)
    end
    
    def mouse
      [@app.mouse_button, @app.mouse_pos[0], @app.mouse_pos[1]]
    end
  end
end
