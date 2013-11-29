class Shoes
  module Swt
    class TextBlockFitter
      def initialize(text_block)
        @text_block = text_block
      end

      def fit_it_in
        # Figure out how much space we have based on prior sibling
        width, height = available_space
        # Generate text layout for that with full text
        # Does it fit?
          # Last layout == the only layout

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

        width = @text_block.dsl.parent.width
        height = @text_block.dsl.parent.height
        if my_index > 0
          prior_sibling = siblings[my_index - 1]
          width -= prior_sibling.width
          height = prior_sibling.height
        end
        [width, height]
      end
    end
  end
end
