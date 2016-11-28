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
          #
          #                                  body_right
          #
          #  head_top        body_left       |\
          #                                  | \
          #  body_top        |---------------|  \  head_right
          #                  |                   \
          #  body_middle     |           (l,t)    |
          #                  |                   /
          #  body_bottom     |---------------|  /
          #                                  | /
          #  head_bottom                     |/
          #

          body_left   = @obj.translate_left + @obj.left - @obj.width * 0.5
          body_right  = @obj.translate_left + @obj.left + @obj.width * 0.1
          body_top    = @obj.translate_top + @obj.top - @obj.width * 0.2
          body_bottom = @obj.translate_top + @obj.top + @obj.width * 0.2

          middle = @obj.translate_top + @obj.top

          head_right  = @obj.translate_left + @obj.left + @obj.width * 0.5
          head_top    = @obj.translate_top + @obj.top - @obj.width * 0.4
          head_bottom = @obj.translate_top + @obj.top + @obj.width * 0.4

          path = ::Swt::Path.new(::Swt.display)
          path.move_to(body_left, middle)
          path.line_to(body_left, body_top)
          path.line_to(body_right, body_top)
          path.line_to(body_right, head_top)
          path.line_to(head_right, middle)
          path.line_to(body_right, head_bottom)
          path.line_to(body_right, body_bottom)
          path.line_to(body_left, body_bottom)
          path.line_to(body_left, middle)

          path
        end
      end

      def clear_path
        @path = nil
      end
    end
  end
end
