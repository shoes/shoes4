# frozen_string_literal: true
class Shoes
  module Swt
    class LinePainter < Common::Painter
      def draw(gc)
        gc.draw_line(@obj.translate_left + @obj.element_left,
                     @obj.translate_top + drawing_top,
                     @obj.translate_left + @obj.element_right + 1,
                     @obj.translate_top + drawing_bottom + 1)
      end

      # Don't do fill setup
      def fill_setup(_gc)
      end
    end
  end
end
