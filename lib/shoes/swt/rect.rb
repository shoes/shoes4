module Shoes
  module Swt
    class Rect
      include Common::Fill
      include Common::Stroke
      include Common::Move
      include Common::Clickable
      include Common::Toggle
      include Common::Clear

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
        clickable self, blk
      end

      attr_reader :dsl
      attr_reader :app
      attr_reader :transform
      attr_reader :painter
      attr_accessor :left, :top, :width, :height, :ln
      attr_reader :corners

      class Painter < Common::Painter
        def path
          path = ::Swt::Path.new(display)
          diameter = @obj.corners * 2
          path.add_arc(@obj.left, @obj.top, diameter, diameter, 180, -90)
          path.add_arc(@obj.left + @obj.width - diameter, @obj.top, diameter, diameter, 90, -90)
          path.add_arc(@obj.left + @obj.width - diameter, @obj.top + @obj.height - diameter, diameter, diameter, 0, -90)
          path.add_arc(@obj.left, @obj.top + @obj.height - diameter, diameter, diameter, -90, -90)
          path.line_to(@obj.left, @obj.top + @obj.corners)
          path
        end

        def fill(gc)
          gc.set_clipping path
          gc.fill_gradient_rectangle(@obj.left, @obj.top, @obj.width, @obj.height, true)
        end

        def draw(gc)
          sw = gc.get_line_width
          gc.draw_round_rectangle(@obj.left+sw/2, @obj.top+sw/2, @obj.width-sw, @obj.height-sw, @obj.corners*2, @obj.corners*2)
        end
      end
    end
  end
end
