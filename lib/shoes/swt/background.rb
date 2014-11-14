class Shoes
  module Swt
    class Background
      extend Forwardable
      include Common::Fill
      include Common::Stroke
      include Common::Remove
      include Common::Visibility
      include BackendDimensionsDelegations

      def_delegators :dsl, :angle

      attr_reader :dsl, :app, :transform, :painter

      def initialize(dsl, app)
        @dsl = dsl
        @app = app

        # fill is potentially a pattern that needs disposing, so hold onto it
        @fill = dsl.fill

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      def corners
        dsl.curve
      end

      def dispose
        @fill.gui.dispose if @fill && @fill.respond_to?(:gui)
      end

      class Painter < RectPainter
        def draw_setup(_gc)
          # don't draw
        end
      end
    end
  end
end
