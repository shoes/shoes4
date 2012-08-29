module Shoes
  module Swt
    class Line
      include Common::Stroke

      # @param [Shoes::Line] dsl The Shoes::Line implemented by this object
      # @param [Shoes::Point] point_a One endpoint of the line
      # @param [Shoes::Point] point_b The other endpoint of the line
      # @param [Hash] opts Options
      def initialize(dsl, point_a, point_b, opts = {})
        @dsl = dsl

        @point_a = point_a
        @point_b = point_b
        @width = opts[:width]
        @height = opts[:height]

        @app = opts[:app]
        @painter = Painter.new(self)
        @app.add_paint_listener(@painter)
      end

      attr_reader :dsl
      attr_reader :point_a, :point_b
      attr_reader :width, :height

      class Painter < Common::Painter
        def draw(gc)
          point_a, point_b = @obj.point_a, @obj.point_b
          gc.draw_line(point_a.x, point_a.y, point_b.x, point_b.y)
        end

        # Don't do fill setup
        def fill_setup(gc)
        end
      end
    end
  end
end
