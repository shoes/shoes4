class Shoes
  module Swt
    class Background
      extend Forwardable
      include Common::Fill
      include Common::Stroke
      include Common::Remove
      include Common::Toggle
      include BackendDimensionsDelegations

      def_delegators :dsl, :corners, :angle

      attr_reader :dsl, :app, :transform, :painter, :opts

      def initialize(dsl, app, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @opts = opts

        # fill is potentially a pattern that needs disposing, so hold onto it
        @fill = opts[:fill]

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      def dispose
        @fill.gui.dispose if @fill && @fill.respond_to?(:gui)
      end

      class Painter < RectPainter
        def draw_setup(gc)
          # don't draw
        end
      end
    end
  end
end
