class Shoes
  module Swt
    class Border
      extend Forwardable
      include Common::Fill
      include Common::Stroke
      include Common::Clear
      include ::Shoes::BackendDimensionsDelegations

      def_delegators :dsl, :angle, :corners

      attr_reader :dsl, :painter, :opts, :transform

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
          # don't draw
        end

        def draw_setup(gc)
          set_position_and_size
          @obj.apply_stroke gc
          true
        end
      end
    end
  end
end
