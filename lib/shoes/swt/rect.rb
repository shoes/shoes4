module Shoes
  module Swt
    class Rect
      include Common::Fill
      include Common::Stroke
      include Common::Move
      include Common::Clickable
      include Common::Toggle

      def initialize(dsl, app, left, top, width, height, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @left = left
        @top = top
        @width = width
        @height = height
        @opts = opts
        @corners = opts[:curve] || 0

        # Move
        @container = @app.real

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
        clickable dsl, blk
      end

      attr_reader :dsl
      attr_reader :transform
      attr_reader :painter
      attr_accessor :left, :top, :width, :height
      attr_reader :corners

      class Painter < Common::Painter
        include Common::Resource

        def fill(gc)
          gc.fill_round_rectangle(@obj.left, @obj.top, @obj.width, @obj.height, @obj.corners*2, @obj.corners*2)
        end

        def draw(gc)
          sw = gc.get_line_width
          gc.draw_round_rectangle(@obj.left+sw/2, @obj.top+sw/2, @obj.width-sw, @obj.height-sw, @obj.corners*2, @obj.corners*2)
        end
      end
    end
  end
end
