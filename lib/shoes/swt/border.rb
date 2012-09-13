module Shoes
  module Swt
    class Border
      include Common::Fill
      include Common::Stroke

      def initialize(dsl, app, left, top, width, height, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @left = left
        @top = top
        @width = width
        @height = height
        @opts = opts
        @corners = opts[:curve] || 0

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      attr_reader :dsl
      attr_reader :transform
      attr_reader :painter
      attr_reader :left, :top, :opts
      attr_reader :corners
      attr_accessor :width, :height

      class Painter < Common::Painter
        include Common::Resource
        def fill(gc)
          # do nothing
        end

        def draw(gc)
          set_width_and_height
          gc.draw_round_rectangle(@obj.left, @obj.top, @obj.width, @obj.height, @obj.corners, @obj.corners)
        end
      end
    end
  end
end
