class Shoes
  module Swt
    class RectPainter < Common::Painter
      def fill(graphics_context)
        graphics_context.fill_round_rectangle(@obj.element_left,
                                              @obj.element_top,
                                              @obj.element_width,
                                              @obj.element_height,
                                              @obj.corners * 2,
                                              @obj.corners * 2)
      end

      def draw(gc)
        stroke_width = gc.get_line_width
        gc.draw_round_rectangle(@obj.element_left + stroke_width / 2,
                                @obj.element_top + stroke_width / 2,
                                @obj.element_width - stroke_width,
                                @obj.element_height - stroke_width,
                                @obj.corners * 2, @obj.corners * 2)
      end
    end
  end
end
