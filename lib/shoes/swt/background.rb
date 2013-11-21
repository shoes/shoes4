class Shoes
  module Swt
    class Background
      extend Forwardable
      include Common::Fill
      include Common::Stroke
      include Common::Clear
      include Common::Toggle
      include BackendDimensionsDelegations

      def_delegators :dsl, :corners, :angle

      attr_reader :dsl, :transform, :painter, :opts

      def initialize(dsl, app, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @container = @app.real
        @opts = opts

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      class Painter < RectPainter
        def fill_setup(gc)
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
