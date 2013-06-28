class Shoes
  class Point
    def initialize(x, y)
      @x, @y = x, y
    end

    attr_reader :x, :y

    # @param [Shoes::Point] other the other point
    # @return [Integer] if this is further left, this.x; otherwise other.x
    def left(other = self)
      [self.x, other.x].min
    end

    # @param [Shoes::Point] other the other point
    # @return [Integer] if this is higher, this.y; otherwise other.y
    def top(other = self)
      [self.y, other.y].min
    end

    # Creates a new point at an offset of (x,y) from this point. Positive
    # offsets move right and down; negative offsets move left and up.
    #
    # @param [Integer] x the x-component of the offset
    # @param [Integer] y the y-component of the offset
    # @return [Shoes::Point] a new point at offset (x,y) from this point
    def to(x, y)
      Shoes::Point.new(@x + x, @y + y)
    end

    def width(other = self)
      (@x - other.x).abs
    end

    def height(other = self)
      (@y - other.y).abs
    end

    def ==(other)
      return other.respond_to?(:x) && @x == other.x && other.respond_to?(:y) && @y == other.y
    end
  end
end
