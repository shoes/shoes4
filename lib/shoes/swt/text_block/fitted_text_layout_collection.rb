class Shoes
  module Swt
    class FittedTextLayoutCollection
      extend Forwardable
      def_delegators :@layouts, :length

      attr_reader :dsl, :default_text_styles

      def initialize(dsl, layouts, default_text_styles)
        @dsl = dsl
        @layouts = layouts
        @default_text_styles = default_text_styles
      end

      def paint_control(graphic_context)
        style_from(dsl.opts)
        style_segment_ranges(dsl.text_styles)
        create_links(dsl.text_styles)
        draw(graphic_context)
        draw_cursor
      end

      def style_from(opts)
        @layouts.each do |layout|
          layout.style_from(default_text_styles, opts)
        end
      end

      def draw(graphic_context)
        @layouts.each do |layout|
          layout.draw(graphic_context)
        end
      end

      def draw_cursor
        TextBlockCursorPainter.new(dsl, self).draw
      end

      def style_segment_ranges(elements_by_range)
        elements_by_range.each do |range, elements|
          style = calculate_style(elements)
          layout_ranges(range).each do |layout, inner_range|
            layout.set_style(style, inner_range)
          end
        end
      end

      def calculate_style(elements)
        elements.inject(default_text_styles) do |current_style, element|
          if element.respond_to?(:opts)
            TextStyleFactory.apply_styles(current_style, element.opts)
          else
            # Didn't know how to style from the element, so punt
            current_style
          end
        end
      end

      def create_links(elements_by_range)
        elements_by_range.each do |range, elements|
          elements.each do |element|
            if supports_links?(element)
              element.gui.create_links_in(layout_ranges(range))
            end
          end
        end
      end

      def supports_links?(element)
        element.respond_to?(:gui) &&
          element.gui &&
          element.gui.respond_to?(:create_links_in)
      end

      def layout_at_text_position(index)
        return @layouts.last if index < 0
        layout_ranges(index..index).first.first
      end

      # If we've got segments that style us across different ranges, it might
      # be in either, or both, of the layouts. This method figures out which
      # layouts apply, and what the relative ranges within each layout to use.
      def layout_ranges(text_range)
        return [] unless @layouts.first # TODO WTF #636
        first_text = @layouts.first.layout.text
        slice = first_text[text_range]

        if slice.nil? || slice.empty?
          results_in_last_layout(text_range, first_text)
        elsif slice.length < text_range.count
          results_spanning_layouts(text_range, first_text, slice)
        else
          results_in_first_layout(text_range)
        end
      end

      def results_in_first_layout(text_range)
        [[@layouts.first, text_range]]
      end

      def results_spanning_layouts(text_range, first_text, slice)
        result = []
        result << [@layouts.first, (text_range.first..first_text.length)]
        # If first == last, then requested range was longer than our one and
        # only layout, so just stick with full range of the first layout.
        if @layouts.first != @layouts.last
          result << [@layouts.last,  (0..text_range.count - slice.length - 1)]
        end
        result
      end

      def results_in_last_layout(text_range, first_text)
        range_start = text_range.first - first_text.length
        range_end   = text_range.last - first_text.length
        [[@layouts.last, (range_start..range_end)]]
      end

      # Returns the relative position within the appropriate layout for index
      # in the overall DSL text
      def relative_text_position(index)
        if at_end?(index)
          relative_end_position
        elsif relative_in_first_layout?(index)
          relative_in_first_layout(index)
        else
          relative_in_last_layout(index)
        end
      end

      def relative_in_first_layout?(index)
        index >= 0 &&
          (@layouts.one? || index < @layouts.first.text.length)
      end

      def at_end?(index)
        index < 0 || index > @dsl.text.length
      end

      def relative_end_position
        @layouts.last.text.length
      end

      def relative_in_first_layout(index)
        index
      end

      def relative_in_last_layout(index)
        index - @layouts.first.text.length
      end

      # This could be smarter, basing height on the actual line the cursor's
      # in. For now, just use the first line's height.
      def cursor_height
        @layouts.first.line_bounds(0).height
      end
    end
  end
end
