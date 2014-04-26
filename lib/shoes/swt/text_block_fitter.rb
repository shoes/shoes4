class Shoes
  module Swt
    class TextBlockFitter
      attr_reader :parent

      def initialize(text_block, current_position)
        @text_block = text_block
        @dsl = @text_block.dsl
        @parent = @dsl.parent
        @current_position = current_position
      end

      # Fitting text works by using either 1 or 2 layouts
      #
      # If the text fits in the height and width available, we use one layout.
      #
      # --------------------------
      # | button | text layout 1 |
      # --------------------------
      #
      # If if the text doesn't fit into that space, then we'll break it into
      # two different layouts.
      #
      # --------------------------
      # | button | text layout 1 |
      # --------------------------
      # | text layout 2 goes here|
      # | in space               |
      # --------------------------
      #           ^
      #
      # If there wasn't any available space in the first layout (very narrow)
      # then we'll make an empty first layout and flow to the second:
      #
      # --------------------------
      # | big big big big button||  < empty layout 1 still present
      # --------------------------
      # | text layout 2 goes here|
      # | in space               |
      # --------------------------
      #           ^
      #
      # When flowing, the position for the next element gets set to the end of
      # the text in the second layout (shown as ^ in the diagram).
      #
      # Stacks properly move to the next whole line as you'd expect.
      #
      def fit_it_in
        width, height = available_space
        if no_space_in_first_layout?(width)
          fit_as_empty_first_layout(height)
        else
          layout = generate_layout(width, @dsl.text)
          if fits_in_one_layout?(layout, height)
            fit_as_one_layout(layout)
          else
            fit_as_two_layouts(layout, height, width)
          end
        end
      end

      def no_space_in_first_layout?(width)
        width <= 0
      end

      def fits_in_one_layout?(layout, height)
        return true if height == :unbounded || layout.line_count == 1
        layout.get_bounds.height <= height
      end

      def fit_as_one_layout(layout)
        [FittedTextLayout.new(layout,
                              @dsl.element_left,
                              @dsl.element_top)]
      end

      def fit_as_two_layouts(layout, height, width)
        first_text, second_text = split_text(layout, height)
        first_layout = generate_layout(width, first_text)

        if second_text.empty?
          fit_as_one_layout(first_layout)
        else
          generate_two_layouts(first_layout, first_text, second_text, height)
        end
      end

      def fit_as_empty_first_layout(height)
        # Although we purposefully empty it out, still need the first layout
        layout = generate_layout(1, @dsl.text)
        layout.text = ""

        height += ::Shoes::Slot::NEXT_ELEMENT_ON_NEXT_LINE_OFFSET.y
        generate_two_layouts(layout, "", @dsl.text, height)
      end

      def generate_two_layouts(first_layout, first_text, second_text, height)
        first_height = first_height(first_layout, first_text, height)
        second_layout = generate_second_layout(second_text)

        [
          FittedTextLayout.new(first_layout,
                               @dsl.element_left,
                               @dsl.element_top),
          FittedTextLayout.new(second_layout,
                                parent.absolute_left + @dsl.margin_left,
                                @dsl.element_top + first_height)
        ]
      end

      def generate_second_layout(second_text)
        generate_layout(@dsl.containing_width, second_text)
      end

      def available_space
        width = @dsl.desired_width
        height = next_line_start - @dsl.absolute_top - 1

        if on_new_line?
          height = :unbounded

          # Try to find a parent container we fit in.
          # If that doesn't work, just bail with [0,0] so we don't crash.
          width = width_from_ancestor if width <= 0
          return [0, 0] if width < 0
        end

        [width, height]
      end

      # If we're positioned outside our containing width, look up the parent
      # chain until we find a width that accomodates us.
      def width_from_ancestor
        width = -1
        current_ancestor = @dsl.parent
        until width > 0 || current_ancestor.nil?
          width = @dsl.desired_width(current_ancestor.width)

          break unless current_ancestor.respond_to?(:parent)
          current_ancestor = current_ancestor.parent
        end
        width
      end

      def next_line_start
        @current_position.next_line_start
      end

      def on_new_line?
        next_line_start <= @dsl.absolute_top
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

      # If first text is empty, height may be smaller than an actual line in
      # the current font. Take our pre-existing allowed height instead.
      def first_height(first_layout, first_text, height)
        first_height = first_layout.get_bounds.height
        first_height = height if first_text.empty?
        first_height
      end
    end
  end
end
