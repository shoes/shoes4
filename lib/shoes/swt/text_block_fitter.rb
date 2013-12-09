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
        layout = generate_layout(@text_block, width, @dsl.text)

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
        [FittedTextLayout.new(layout,
                              @dsl.absolute_left + @dsl.margin_left,
                              @dsl.absolute_top + @dsl.margin_top)]
      end

      def fit_as_two_layouts(layout, height, width)
        first_text, second_text = split_text(layout, height)
        first_layout = generate_layout(@text_block, width, first_text)
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
        parent_width, _ = space_from_parent
        second_layout = generate_layout(@text_block, parent_width, second_text)
      end

      def available_space
        # TODO: This sibling checking is probably not needed anymore
        # With the current position, we can probably just calculate our space
        # but don't have time to lock that down right now.
        siblings = @text_block.dsl.parent.contents.to_ary
        my_index = siblings.find_index(@text_block.dsl)

        if my_index == 0
          space_from_parent
        else
          space_from_sibling(siblings[my_index - 1])
        end
      end

      def space_from_parent
        # TODO: Height should take into account used up lines above in parent
        [@text_block.dsl.parent.width, @text_block.dsl.parent.height]
      end

      def space_from_sibling(sibling)
        width = @text_block.dsl.parent.width - @current_position.x
        height = @current_position.max_bottom - @current_position.y
        [width, height]
      end

      # TODO: Is it worth having this take text_block?
      # Always passing @text_block in this class for it... just use ivar?
      def generate_layout(text_block, width, text)
        text_block.generate_layout(width, text)
      end

      def split_text(layout, height)
        ending_offset = 0
        height_so_far = 0

        offsets = layout.line_offsets
        offsets.each_with_index do |_, i|
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

      def draw(graphics_context)
        layout.draw(graphics_context, left, top)
      end
    end

  end
end
