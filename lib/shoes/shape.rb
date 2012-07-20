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

    attr_reader :blk
    attr_reader :x, :y

    # Creates a new Shoes::Shape
    #
    # This is a composite shape, which has one or more components.
    #
    # Implementation frameworks should pass in any required arguments
    # through the +opts+ hash.
    def initialize(opts = {}, blk = nil)
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)
      @blk = blk

      # Component shapes
      @components = []

      # GUI
      @style.delete(:gui)
      @gui = Shoes.configuration.backend_for(self, @style)

      instance_eval &@blk unless @blk.nil?
    end

    def left
      @left || @components.map(&:left).min || 0
    end

    def top
      @top || @components.map(&:top).min || 0
    end

    def right
      @right || @components.map { |c| c.left + c.width }.max || left
    end

    def bottom
      @bottom || @components.map { |c| c.top + c.height }.max || top
    end

    def width
      (left - right).abs
    end

    def height
      (top - bottom).abs
    end

    # Moves the shape
    #
    # Moves each component so bounds calculations still work.
    # @param [Integer] left The new left value
    # @param [Integer] top The new top value
    # @return [Shoes::Shape] This shape
    def move(left, top)
      relative_left = offset(self.left, left)
      relative_top = offset(self.top, top)
      @components.each do |c|
        c_left = c.left
        c_top = c.top
        c.move(c_left + relative_left, c_top + relative_top)
      end
      @left, @top, @right, @bottom = left, top, nil, nil
      @gui.move(@left, @top)
      self
    end

    # Draws a line from the current position to the given point
    #
    # @param [Integer] x The new point's x-value
    # @param [Integer] y The new point's y-value
    # @return [Shoes::Shape] This shape
    def line_to(x, y)
      @components << ::Shoes::Line.new(@x, @y, x, y, @style)
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

    # Gives the relative offset of the new position from original position.
    # This calculation is for a single coordinate value, e.g. an x or a y.
    #
    # @param [Integer] original The original position
    # @param [Integer] new The new position
    # @return [Integer] A value that should be added to the current position in order to
    #   move to the new position.
    def offset(original, new)
      relative = (new - original).abs
      relative = -relative if new < original
      relative
    end
  end
end
