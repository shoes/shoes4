require 'shoes/common_methods'
require 'shoes/color'

module Shoes
  class Background
    include Shoes::CommonMethods

    attr_reader :parent, :blk, :gui
    attr_reader :color, :opts
    attr_reader :x, :y, :width, :height
    alias :fill :color

    def initialize(parent, color, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @opts = opts
      @app = opts[:app]

      @color = color
      @color = opts[:fill] if opts.has_key? :fill

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
    end

    # paint_event needs to have .width and .height
    def coords(paint_event)
      coords = Hash.new
      coords[:width] = set_width(paint_event)
      coords[:height] = set_height(paint_event)
      coords[:x] = set_x(paint_event, coords[:width])
      coords[:y] = set_y(paint_event, coords[:height])

      coords
    end

    def default
      parent.default_options[:background]
    end

    private

    def set_width(window)
      if @opts.has_key? :width
        @opts[:width]
      elsif @opts.has_key? :radius
        2*@opts[:radius]
      elsif @opts.has_key?(:left) && @opts.has_key?(:right)
        window.width - (@opts[:right] + @opts[:left])
      else
        window.width
      end
    end

    def set_height(window)
      if @opts.has_key? :height
        height = @opts[:height]
      elsif @opts.has_key? :radius
        2*@opts[:radius]
      elsif @opts.has_key?(:top) && @opts.has_key?(:bottom)
        window.height - (@opts[:top] + @opts[:bottom])
      else
        window.height
      end
    end

    def set_x(window, width)
      if @opts.has_key? :left
        @opts[:left]
      # if width is != window.width then it was altered in some way and we
      # have to adjust. Otherwise, 0 is a valid answer.
      elsif @opts.has_key?(:right) && (width != window.width)
        window.width - (width + @opts[:right])
      else
        0
      end
    end

    def set_y(window, height)
      if @opts.has_key? :top
        @opts[:top]
      # height is != the window.height then it was altered and we need to adjust
      elsif @opts.has_key?(:bottom) && (height != window.height)
        window.height - (height + @opts[:bottom])
      else
        0
      end
    end
  end
end
