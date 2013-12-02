class Shoes
  module Swt
    class TextBlockFitter
      def initialize(text_block)
        @text_block = text_block
        @dsl = text_block.dsl
      end

      def fit_it_in
        width, height = available_space
        layout = generate_layout(@text_block, width, @dsl.text)

        if layout.get_bounds.height <= height
          return layout
        end

        puts "NOT THE RIGHT THING!"
        return layout

        # Doesn't fit?
          # Determine cut-off point for the first text layout
          # Advance to next line
          # Generate text layout with remaining text

        # Calculate finish-point in last line of text layout

        # Return both layout(s) and finish-point
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
    end
  end
end
