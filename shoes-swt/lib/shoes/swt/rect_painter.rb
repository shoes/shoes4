# frozen_string_literal: true
class Shoes
  module Swt
    class RectPainter < Common::Painter
      def fill(gc)
        gc.fill_round_rectangle(@obj.translate_left + @obj.element_left + inset,
                                @obj.translate_top + @obj.element_top + inset,
                                @obj.element_width - inset * 2,
                                @obj.element_height - inset * 2,
                                @obj.corners * 2,
                                @obj.corners * 2)
      end

      def draw(gc)
        stroke_width = gc.get_line_width
        gc.draw_round_rectangle(@obj.translate_left + @obj.element_left + stroke_width / 2,
                                @obj.translate_top + @obj.element_top + stroke_width / 2,
                                @obj.element_width - stroke_width,
                                @obj.element_height - stroke_width,
                                @obj.corners * 2, @obj.corners * 2)
      end

      def inset
        # If drawing a stroke around the shape, inset the fill so the draw
        # isn't inside bounds of fill because of integer division remainders.
        inset_fill? ? 1 : 0
      end

      def inset_fill?
        rounded? && strokewidth?
      end

      def rounded?
        (@obj.corners || 0) > 0
      end

      def strokewidth?
        (@obj.dsl.style[:strokewidth] || 0) > 0
      end
    end
  end
end
