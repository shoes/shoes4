class Shoes
  module Swt
    class ArrowPainter < Common::Painter
      def fill(gc)
        gc.fill_path(path)
      end

      def draw(gc)
        gc.draw_path(path)
      end

      def path
        @path ||= begin
          path = ::Swt::Path.new(::Swt.display)

          path.move_to(@obj.left - @obj.width / 2, @obj.top)
          path.line_to(@obj.left - @obj.width / 2, @obj.top - @obj.width * 0.20)
          path.line_to(@obj.left + @obj.width * 0.10, @obj.top - @obj.width * 0.20)
          path.line_to(@obj.left + @obj.width * 0.10, @obj.top - @obj.width * 0.20 - @obj.width * 0.20)
          path.line_to(@obj.left + @obj.width * 0.50, @obj.top)
          path.line_to(@obj.left + @obj.width * 0.10, @obj.top + @obj.width * 0.20 + @obj.width * 0.20)
          path.line_to(@obj.left + @obj.width * 0.10, @obj.top + @obj.width * 0.20)
          path.line_to(@obj.left - @obj.width / 2, @obj.top + @obj.width * 0.20)
          path.line_to(@obj.left - @obj.width / 2, @obj.top - @obj.width * 0.20)
          path.line_to(@obj.left - @obj.width / 2, @obj.top)

          path
        end
      end

      def clear_path
        @path = nil
      end
    end
  end
end
