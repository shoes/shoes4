class Shoes
  module Swt
    class TextBlockFitter
      def initialize(text_block, current_position)
        @text_block = text_block
        @dsl = text_block.dsl
        @current_position = current_position
      end

      # TODO: Give layout diagram here and describe the general 1 vs 2 layout
      # algorthim that we're using, and why it works
      def fit_it_in
        width, height = available_space
        layout = generate_layout(width, @dsl.text)

        if fits_in_one_layout?(layout, height)
          fit_as_one_layout(layout)
        else
          fit_as_two_layouts(layout, height, width)
        end
      end

      def fits_in_one_layout?(layout, height)
        layout.get_bounds.height <= height
      end

      def fit_as_one_layout(layout)
        # TODO: Make sure we deal with explicit widths from the DSL
        [FittedTextLayout.new(layout,
                              @dsl.absolute_left + @dsl.margin_left,
                              @dsl.absolute_top + @dsl.margin_top)]
      end

      def fit_as_two_layouts(layout, height, width)
        # TODO: Make sure we deal with explicit widths from the DSL
        first_text, second_text = split_text(layout, height)
        first_layout = generate_layout(width, first_text)
        second_layout = generate_second_layout(second_text)

        [
          FittedTextLayout.new(first_layout,
                               @dsl.absolute_left + @dsl.margin_left,
                               @dsl.absolute_top + @dsl.margin_top),
          FittedTextLayout.new(second_layout,
                                @dsl.parent.absolute_left + @dsl.margin_left,
                                @dsl.absolute_top + @dsl.margin_top + first_layout.get_bounds.height)
        ]
      end

      def generate_second_layout(second_text)
        parent_width = @text_block.dsl.parent.width
        second_layout = generate_layout(parent_width, second_text)
      end

      def available_space
        width = parent.absolute_left + parent.width - @current_position.x
        height = @current_position.next_line_start - @current_position.y
        [width, height]
      end

      def parent
        @text_block.dsl.parent
      end

      def generate_layout(width, text)
        @text_block.generate_layout(width, text)
      end

      def split_text(layout, height)
        ending_offset = 0
        height_so_far = 0

        offsets = layout.line_offsets
        offsets[0...-1].each_with_index do |_, i|
          height_so_far += layout.line_metrics(i).height
          break if height_so_far > height

          ending_offset = offsets[i+1]
        end
        [layout.text[0...ending_offset], layout.text[ending_offset..-1]]
      end
    end

    class FittedTextLayout
      attr_reader :layout, :left, :top

      def initialize(layout, left, top)
        @layout = layout
        @left = left
        @top = top
      end

      # We assume the text layout doesn't have varying line heights, so we can
      # treat the first line as the typical height for the whole text block.
      def line_height
        @layout.get_line_bounds(0).height
      end

      def get_location(cursor)
        @layout.get_location(cursor, false)
      end

      def text
        @layout.text
      end

      def draw(graphics_context)
        layout.draw(graphics_context, left, top)
      end
    end

  end
end
