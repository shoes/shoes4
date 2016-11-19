class Shoes
  module Swt
    class RectPainter < Common::Painter
      def fill(gc)
        # If drawing a stroke around the shape, inset the fill so the draw
        # isn't inside bounds of fill because of integer division remainders.
        stroke_width = @obj.dsl.style[:strokewidth]
        bump = stroke_width && stroke_width > 0 ? 1 : 0

        gc.fill_round_rectangle(@obj.element_left + bump,
                                @obj.element_top + bump,
                                @obj.element_width - bump * 2,
                                @obj.element_height - bump * 2,
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
