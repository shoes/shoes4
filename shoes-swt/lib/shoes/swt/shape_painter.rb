# frozen_string_literal: true
class Shoes
  module Swt
    class ShapePainter < Common::Painter
      def fill(gc)
        gc.fill_path(@obj.element)
      end

      def draw(gc)
        gc.draw_path(@obj.element)
      end
    end
  end
end
