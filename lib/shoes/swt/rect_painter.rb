class Shoes
  module Swt
    class RectPainter < Common::Painter
      def path
        path = ::Swt::Path.new(display)
        # Windows won't do the rounded rectangle path with a corner radius of 0
        if @obj.corners.zero?
          path.add_rectangle(@obj.absolute_left, @obj.absolute_top, @obj.width, @obj.height)
        else
          diameter = @obj.corners * 2
          path.add_arc(@obj.absolute_left, @obj.absolute_top, diameter, diameter, 180, -90)
          path.add_arc(@obj.absolute_left + @obj.width - diameter, @obj.absolute_top, diameter, diameter, 90, -90)
          path.add_arc(@obj.absolute_left + @obj.width - diameter, @obj.absolute_top + @obj.height - diameter, diameter, diameter, 0, -90)
          path.add_arc(@obj.absolute_left, @obj.absolute_top + @obj.height - diameter, diameter, diameter, -90, -90)
          path.line_to(@obj.absolute_left, @obj.absolute_top + @obj.corners)
        end
        path
      end

      def fill(gc)
        gc.fill_round_rectangle(@obj.absolute_left, @obj.absolute_top, @obj.width, @obj.height, @obj.corners*2, @obj.corners*2)
      end

      def draw(gc)
        sw = gc.get_line_width
        gc.draw_round_rectangle(@obj.absolute_left+sw/2, @obj.absolute_top+sw/2, @obj.width-sw, @obj.height-sw, @obj.corners*2, @obj.corners*2)
      end
    end
  end
end