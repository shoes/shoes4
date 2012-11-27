require 'shoes/common_methods'
require 'shoes/common/fill'
require 'shoes/common/stroke'
require 'shoes/common/style'
require 'shoes/line'

module Shoes
  class Shape
    include Shoes::CommonMethods
    include Shoes::Common::Fill
    include Shoes::Common::Stroke
    include Shoes::Common::Style

    # Creates a new Shoes::Shape
    #
    def initialize(app, opts = {}, blk = nil)
      @app = app
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1
      @blk = blk

      # GUI
      @gui = Shoes.backend_for(self, @style)

      instance_eval &@blk unless @blk.nil?
    end

    attr_reader :app, :blk
    attr_reader :x, :y

    def left
      @left || 0
    end

    def top
      @top || 0
    end

    def right
      @right || left
    end

    def bottom
      @bottom || top
    end

    def width
      (left - right).abs
    end

    def height
      (top - bottom).abs
    end

    # Moves the shape
    #
    # @param [Integer] left The new left value
    # @param [Integer] top The new top value
    # @return [Shoes::Shape] This shape
    def move(left, top)
      @right += offset(@left, left) if @right
      @bottom += offset(@top, top) if @bottom
      @left = left
      @top = top
      @gui.move(@left, @top)
      self
    end

    # Draws a line from the current position to the given point
    #
    # @param [Integer] x The new point's x-value
    # @param [Integer] y The new point's y-value
    # @return [Shoes::Shape] This shape
    def line_to(x, y)
      update_bounds(@x, @y, x, y)
      @x, @y = x, y
      @gui.line_to(x, y)
      self
    end

    # Moves the drawing "pen" to the given point
    #
    # @param [Integer] x The new point's x-value
    # @param [Integer] y The new point's y-value
    # @return [Shoes::Shape] self This shape
    def move_to(x, y)
      @x, @y = x, y
      @gui.move_to(x, y)
      self
    end

    private
    # Gives the relative offset of the new position from original position.
    # This calculation is for a single coordinate value, e.g. an x or a y.
    #
    # @param [Integer] original The original position
    # @param [Integer] new The new position
    # @return [Integer] A value that should be added to the current position in order to
    #   move to the new position.
    def offset(original, new)
      return 0 unless original && new
      relative = (new - original).abs
      relative = -relative if new < original
      relative
    end

    # Updates the bounds of this shape to include the rectangle described by
    # (x1, y1) and (x2, y2)
    #
    # @param [Integer] x The x-value of the coordinate
    # @param [Integer] y The y-value of the coordinate
    # @return nil
    def update_bounds(x1, y1, x2, y2)
      xs = [x1, x2]
      ys = [y1, y2]
      x_min = xs.min
      x_max = xs.max
      y_min = ys.min
      y_max = ys.max
      @left = x_min unless @left && x_min > @left
      @top = y_min unless @top && y_min > @top
      @right = x_max unless @right && x_max < @right
      @bottom = y_max unless @bottom && y_max < @bottom
      nil
    end
  end
end
