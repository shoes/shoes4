class Shoes
  module Swt
    class LinePainter < Common::Painter
      def draw(gc)
        gc.draw_line(@obj.dsl.translate_left + @obj.element_left,
                     @obj.dsl.translate_top + @obj.element_top,
                     @obj.dsl.translate_left + @obj.element_right + 1,
                     @obj.dsl.translate_top + @obj.element_bottom + 1)
      end

      # Don't do fill setup
      def fill_setup(_gc)
      end
    end
  end
end
