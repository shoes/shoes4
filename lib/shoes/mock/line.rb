module Shoes
  module Mock
    class Line
      include Shoes::Mock::CommonMethods

      def initialize(dsl, app, point_a, point_b, opts = {})
        @dsl = dsl
        @app = app
        @point_a = point_a
        @point_b = point_b
        @left = [point_a.x, point_b.x].min
        @top = [point_a.y, point_b.y].min
        @width = (point_a.x - point_b.x).abs
        @height = (point_a.y - point_b.y).abs
      end

      attr_reader :point_a, :point_b
      attr_reader :left, :top, :width, :height

      def move(x, y)
        @left, @top = x, y
      end
    end
  end
end
