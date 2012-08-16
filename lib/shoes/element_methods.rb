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
      Shoes::List_box.new self, opts, blk
    end

    def flow(opts = {}, &blk)
      opts.merge! :app => @app
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
      opts.merge! :app => @app
      Shoes::Arc.new(left, top, width, height, angle1, angle2, opts)
    end

    # Draws a line from (x1,y1) to (x2,y2)
    def line(x1, y1, x2, y2, opts = {})
      opts[:app] = self
      Shoes::Line.new x1, y1, x2, y2, style.merge(opts)
    end

    # Draws an oval at (left, top) with either
    #
    # Signatures:
    #   - oval(left, top, radius)
    #   - oval(left, top, width, height)
    #   - oval(styles)
    #       where styles is a hash with any or all of these keys:
    #         left, top, width, height, radius, center
    def oval(*opts)
      oval_style = opts.last.class == Hash ? opts.pop : {}
      oval_style[:app] = self
      Shoes::Oval.new(*opts, style.merge(oval_style))
    end

    # Creates a new Shoes::Shape object
    def shape(shape_style={}, &blk)
      shape_style[:app] = self
      Shoes::Shape.new(style.merge(shape_style), blk)
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
      Shoes::TextBlock.new(self, text, BANNER_FONT_SIZE, opts, blk)
    end

    def title(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::TextBlock.new(self, text, TITLE_FONT_SIZE, opts, blk)
    end

    def subtitle(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::TextBlock.new(self, text, SUBTITLE_FONT_SIZE, opts, blk)
    end

    def tagline(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::TextBlock.new(self, text, TAGLINE_FONT_SIZE, opts, blk)
    end

    def caption(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::TextBlock.new(self, text, CAPTION_FONT_SIZE, opts, blk)
    end

    def para(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::TextBlock.new(self, text, PARA_FONT_SIZE, opts, blk)
    end

    def inscription(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::TextBlock.new(self, text, INSCRIPTION_FONT_SIZE, opts, blk)
    end
  end
end
