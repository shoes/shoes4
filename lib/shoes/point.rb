module Shoes
  class Point
    def initialize(x, y)
      @x, @y = x, y
    end

    attr_reader :x, :y
  end
end
