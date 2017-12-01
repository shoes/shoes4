# frozen_string_literal: true

class Shoes
  module Swt
    class TextBlock
      class CursorPainter
        def initialize(text_block_dsl, collection)
          @text_block_dsl = text_block_dsl
          @collection = collection
        end

        def draw
          if @text_block_dsl.cursor
            draw_textcursor
          else
            remove_textcursor
          end
        end

        def draw_textcursor
          segment = @collection.segment_at_text_position(@text_block_dsl.cursor)
          relative_cursor = @collection.relative_text_position(@text_block_dsl.cursor)
          position = segment.get_location(relative_cursor)

          move_if_necessary(segment.element_left + position.x,
                            segment.element_top + position.y)
        end

        # It's important to only move when necessary to avoid constant redraws
        def move_if_necessary(x, y)
          return if textcursor.left == x && textcursor.top == y
          move_textcursor(x, y)
        end

        def move_textcursor(x, y)
          height = textcursor.height
          textcursor.move(x, y, x, y + height)
          textcursor.show
        end

        def textcursor
          @text_block_dsl.textcursor @collection.cursor_height
        end

        def remove_textcursor
          return unless @text_block_dsl.textcursor?

          @text_block_dsl.textcursor.remove
          @text_block_dsl.textcursor = nil
        end
      end
    end
  end
end
