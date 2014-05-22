class Shoes
  module Swt
    class TextBlockCursorPainter
      def initialize(dsl, collection, fitted_layouts)
        @dsl = dsl
        @collection = collection
        @fitted_layouts = fitted_layouts
      end

      def draw
        if @dsl.cursor
          draw_textcursor
        else
          remove_textcursor
        end
      end

      def draw_textcursor
        layout = @collection.layout_at_text_position(@dsl.cursor)
        x, y = new_position(layout)

        # It's important to only move when necessary to avoid constant redraws
        unless textcursor.left == x && textcursor.top == y
          move_textcursor(x, y)
        end
      end

      def new_position(layout)
        relative_cursor = @collection.relative_text_position(@dsl.cursor)
        position = layout.get_location(relative_cursor)
        [layout.element_left + position.x, layout.element_top + position.y]
      end

      def move_textcursor(x, y)
        textcursor.move(x, y)
        textcursor.show
      end

      def first_layout
        @fitted_layouts.first
      end

      def textcursor
        @dsl.textcursor cursor_height
      end

      # This could be smarter, basing height on the actual line the cursor's
      # in. For now, just use the first line's height.
      def cursor_height
        first_layout.layout.get_line_bounds(0).height
      end

      def remove_textcursor
        return unless @dsl.has_textcursor?

        @dsl.textcursor.remove
        @dsl.textcursor = nil
      end
    end
  end
end
