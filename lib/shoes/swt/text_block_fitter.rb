class Shoes
  module Swt
    class TextBlockFitter
      def initialize(text_block)
        @text_block = text_block
        @dsl = text_block.dsl
      end

      class FittedTextLayout
        attr_reader :layout, :left, :top

        def initialize(layout, left, top)
          @layout = layout
          @left = left
          @top = top
        end

        def draw(graphics_context)
          layout.draw graphics_context, left, top
        end
      end

      def fit_it_in
        width, height = available_space
        layout = generate_layout(@text_block, width, @dsl.text)

        if layout.get_bounds.height <= height
          [FittedTextLayout.new(layout,
                                @dsl.absolute_left + @dsl.margin_left,
                                @dsl.absolute_top + @dsl.margin_top)]
        else
          # Doesn't fit?
            # Determine cut-off point for the first text layout
            # Advance to next line
            # Generate text layout with remaining text

          # Calculate finish-point in last line of text layout

          # Return both layout(s) and finish-point
          []
        end

      end

      def available_space
        # TODO: Badly assumes all siblings are on same line. Fix that!
        siblings = @text_block.dsl.parent.contents.to_ary
        my_index = siblings.find_index(@text_block.dsl)

        if my_index == 0
          space_from_parent
        else
          space_from_sibling(siblings[my_index - 1])
        end
      end

      def space_from_parent
        [@text_block.dsl.parent.width, @text_block.dsl.parent.height]
      end

      def space_from_sibling(sibling)
        width = @text_block.dsl.parent.width - sibling.right
        height = sibling.height
        [width, height]
      end

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
  end
end
