require 'shoes/animation'
require 'shoes/sound'
require 'shoes/button'
require 'shoes/color'
require 'shoes/flow'
require 'shoes/line'
require 'shoes/oval'
require 'shoes/shape'
require 'shoes/text_block'
require 'shoes/list_box'

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

    def list_box(opts = {}, &blk)
      opts.merge! :app => @app
      Shoes::List_box.new(self, opts, blk)
    end

    def flow(opts = {}, &blk)
      opts.merge! :app => @app
      swt_flow = Shoes::Flow.new(self, opts, blk)
    end


    def button(text, opts={}, &blk)
      opts.merge! :app => @app
      button = Shoes::Button.new(self, text, opts, blk)
      #@elements[button.to_s] = button
      #button
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
      Shoes::Animation.new(opts, blk)
    end

    # similar controls as Shoes::Video (#video)
    def sound(soundfile, opts = {}, &blk)
      playable_sound = Shoes::Sound.new(self.gui, soundfile, opts, &blk)
    end

    #
    #def image(path, opts={})
    #  image = Image.new(path, @current_panel, opts)
    #  @elements[image.identifier] = image
    #  image
    #end
    #
    #def edit_line(opts={})
    #  eline = Edit_line.new(@current_panel, opts)
    #  @elements[eline.identifier] = eline
    #  eline
    #end
    #
    #def text_box(opts={})
    #  tbox = Text_box.new(@current_panel, opts)
    #  @elements[tbox.identifier] = tbox
    #  tbox
    #end
    #
    #def check(opts={}, &blk)
    #  cbox = Check.new(@current_panel, opts)
    #  @elements[cbox.identifier] = cbox
    #  cbox
    #end
    #

    # Draws a line from (x1,y1) to (x2,y2)
    def line(x1, y1, x2, y2, opts = {})
      Shoes::Line.new(x1, y1, x2, y2, style.merge(opts))
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
    def banner(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Text_block.new(self, text, 48, opts, blk)
    end

    def title(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Text_block.new(self, text, 26, opts, blk) #34
    end

    def subtitle(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Text_block.new(self, text, 26, opts, blk)
    end

    def tagline(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Text_block.new(self, text, 18, opts, blk)
    end

    def caption(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Text_block.new(self, text, 14, opts, blk)
    end

    def para(text, opts={}, &blk)
      puts "davor"
      opts.merge! :app => @app
      Shoes::Text_block.new(self, text, 12, opts, blk)
    end

    def inscription(text, opts={}, &blk)
      opts.merge! :app => @app
      Shoes::Text_block.new(self, text, 10, opts, blk)
    end
  end
end
