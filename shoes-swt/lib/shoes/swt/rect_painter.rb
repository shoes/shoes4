class Shoes
  module Swt
    class RectPainter < Common::Painter
      def fill(gc)
        # If drawing a stroke around the shape, inset the fill so the draw
        # isn't inside bounds of fill because of integer division remainders.
        inset = inset_fill? ? 1 : 0

        gc.fill_round_rectangle(@obj.element_left + inset,
                                @obj.element_top + inset,
                                @obj.element_width - inset * 2,
                                @obj.element_height - inset * 2,
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

      def inset_fill?
        rounded? && has_strokewidth?
      end

      def rounded?
        @obj.corners || 0 > 0
      end

      def has_strokewidth?
        @obj.dsl.style[:strokewidth] || 0 > 0
      end
    end
  end
end
