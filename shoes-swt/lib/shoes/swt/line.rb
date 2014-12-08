class Shoes
  module Swt
    class Line
      include Common::Clickable
      include Common::Stroke
      include Common::Visibility
      include Common::Remove
      include Common::PainterUpdatesPosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :app
      attr_reader :transform

      def initialize(dsl, app)
        @dsl, @app = dsl, app
        @painter = Painter.new(self)
        @app.add_paint_listener(@painter)

        @transform = nil # Not necessary for this shape
      end

      def angle
        @dsl.angle
      end

      private

      class Painter < Common::Painter
        def draw(gc)
          point_a, point_b = @obj.dsl.point_a, @obj.dsl.point_b
          gc.draw_line(point_a.x, point_a.y, point_b.x, point_b.y)
        end

        # Don't do fill setup
        def fill_setup(_gc)
        end
      end
    end
  end
end
