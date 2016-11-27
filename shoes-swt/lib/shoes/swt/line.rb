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
        @dsl = dsl
        @app = app

        @painter = LinePainter.new(self)
        @app.add_paint_listener(@painter)

        @transform = nil # Not necessary for this shape
      end

      def angle
        @dsl.angle
      end

      class LinePainter < Common::Painter
        def draw(gc)
          gc.draw_line(@obj.dsl.translate_left + @obj.element_left,
                       @obj.dsl.translate_top + @obj.element_top,
                       @obj.dsl.translate_left + @obj.element_right + 1,
                       @obj.dsl.translate_top + @obj.element_bottom + 1)
        end

        # Don't do fill setup
        def fill_setup(_gc)
        end
      end
    end
  end
end
