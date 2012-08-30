module Shoes
  module Mock
    class Line
      include Shoes::Mock::CommonMethods

      def initialize(dsl, app, point_a, point_b, opts = {})
        @dsl = dsl
        @app = app
        @point_a = point_a
        @point_b = point_b
        @width = opts[:width]
        @height = opts[:height]
      end

      attr_reader :point_a, :point_b
      attr_reader :width, :height
    end
  end
end
