class Shoes
  module Swt
    class Border
      extend Forwardable
      include Common::Fill
      include Common::Stroke
      include Common::Remove
      include Common::Visibility
      include ::Shoes::BackendDimensionsDelegations

      def_delegators :dsl, :angle

      attr_reader :app, :dsl, :painter, :transform

      def initialize(dsl, app)
        @dsl = dsl
        @app = app
        @container = @app.real

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      def corners
        dsl.curve
      end

      class Painter < RectPainter
        def fill_setup(_gc)
          # don't draw
        end

        def draw_setup(gc)
          @obj.apply_stroke gc
          true
        end
      end
    end
  end
end
