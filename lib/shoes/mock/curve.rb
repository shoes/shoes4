module Shoes
  module Mock
    class Curve
      include Shoes::Mock::CommonMethods

      def initialize(dsl, app, point_1, control_1, control_2, point_2, opts = {})
        @dsl, @app = dsl, app
        @point_1, @control_1, @control_2, @point_2 = point_1, control_1, control_2, point_2

        @left = [point_1.x, control_1.x, control_2.x, point_2.x].min
        @top = [point_1.y, control_1.y, control_2.y, point_2.y].min

        right = [point_1.x, control_1.x, control_2.x, point_2.x].max
        bottom = [point_1.y, control_1.y, control_2.y, point_2.y].max

        @width = right-@left
        @height = bottom-@top
      end

      attr_reader :point_1, :control_1, :control_2, :point_2
      attr_reader :left, :top, :width, :height
    end
  end
end
