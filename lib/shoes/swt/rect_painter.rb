class Shoes
  module Swt
    class RectPainter < Common::Painter
      def path
        path = ::Swt::Path.new(display)
        # Windows won't do the rounded rectangle path with a corner radius of 0
        if @obj.corners.zero?
          path.add_rectangle(@obj.element_left, @obj.element_top,
                             @obj.element_width, @obj.element_height)
        else
          diameter = @obj.corners * 2
          path.add_arc(@obj.element_left, @obj.element_top,
                       diameter, diameter, 180, -90)
          path.add_arc(@obj.element_right - diameter, @obj.element_top,
                       diameter, diameter, 90, -90)
          path.add_arc(@obj.element_right - diameter,
                       @obj.element_bottom - diameter, diameter, diameter, 0, -90)
          path.add_arc(@obj.element_left, @obj.element_bottom - diameter,
                       diameter, diameter, -90, -90)
          path.line_to(@obj.element_left, @obj.element_top + @obj.corners)
        end
        path
      end

      def fill(graphics_context)
        graphics_context.fill_round_rectangle(@obj.element_left,
                                              @obj.element_top,
                                              @obj.element_width,
                                              @obj.element_height,
                                              @obj.corners*2,
                                              @obj.corners*2)
      end

      def draw(gc)
        stroke_width = gc.get_line_width
        gc.draw_round_rectangle(@obj.element_left+stroke_width/2,
                                @obj.element_top+stroke_width/2,
                                @obj.element_width-stroke_width,
                                @obj.element_height-stroke_width,
                                @obj.corners*2, @obj.corners*2)
      end
    end
  end
end