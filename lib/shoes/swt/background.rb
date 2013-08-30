class Shoes
  module Swt
    class Background
      include Common::Fill
      include Common::Stroke
      include Common::Clear
      include BackendDimensionsDelegations

      attr_reader :dsl, :transform, :painter, :opts

      def initialize(dsl, app, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @container = @app.real
        @opts = opts

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      def corners
        dsl.corners
      end

      def angle
        dsl.angle
      end

      class Painter < RectPainter
        def fill_setup(gc)
          set_position_and_size
          @obj.apply_fill gc
          true
        end

        def draw_setup(gc)
          # don't draw
        end
      end
    end
  end
end
