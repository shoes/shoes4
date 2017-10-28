# frozen_string_literal: true
class Shoes
  module Swt
    class ShapePainter < Common::Painter
      def before_painted
        if @obj.scroll_top_applied != @obj.dsl.parent.scroll_top
          # Put back what we've already done
          @obj.transform.translate(0, @obj.scroll_top_applied) if @obj.scroll_top_applied

          # Move it!
          @obj.transform.translate(0, -@obj.dsl.parent.scroll_top)
          @obj.scroll_top_applied = @obj.dsl.parent.scroll_top
        end
      end

      def fill(gc)
        gc.fill_path(@obj.element)
      end

      def draw(gc)
        gc.draw_path(@obj.element)
      end
    end
  end
end
