class Shoes
  module Swt
    class RectPainter < Common::Painter
      def fill(gc)
        # If drawing a stroke around the shape, inset the fill so the draw
        # isn't inside bounds of fill because of integer division remainders.
        stroke_width = @obj.dsl.style[:strokewidth] || 0
        bump_by = stroke_width == 1 ? 1 : stroke_width / 2

        gc.fill_round_rectangle(@obj.element_left + bump_by,
                                @obj.element_top + bump_by,
                                @obj.element_width - stroke_width,
                                @obj.element_height - stroke_width,
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
