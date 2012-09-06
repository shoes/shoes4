module Shoes
  module Mock
    class Line
      include Shoes::Mock::CommonMethods

      def initialize(dsl, app, point_a, point_b, opts = {})
        @dsl, @app = dsl, app
        @point_a, @point_b = point_a, point_b
        @left = point_a.left(point_b)
        @top = point_a.top(point_b)
        @width = point_a.width(point_b)
        @height = point_a.height(point_b)
      end

      attr_reader :point_a, :point_b
      attr_reader :left, :top, :width, :height

      def move(x, y)
        @left, @top = x, y
      end
    end
  end
end
