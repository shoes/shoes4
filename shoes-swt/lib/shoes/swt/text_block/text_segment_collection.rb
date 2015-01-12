class Shoes
  module Swt
    class TextBlock
      class TextSegmentCollection
        extend Forwardable
        def_delegators :@segments, :length

        attr_reader :dsl, :default_text_styles

        def initialize(dsl, segments, default_text_styles)
          @dsl = dsl
          @segments = segments
          @default_text_styles = default_text_styles
        end

        def paint_control(graphic_context)
          style_from(dsl.style)
          style_segment_ranges(dsl.text_styles)
          create_links(dsl.text_styles)
          draw(graphic_context)
          draw_cursor
        end

        def style_from(style)
          @segments.each do |segment|
            segment.style_from(default_text_styles, style)
          end
        end

        def draw(graphic_context)
          @segments.each do |segment|
            segment.draw(graphic_context)
          end
        end

        def draw_cursor
          TextBlock::CursorPainter.new(dsl, self).draw
        end

        def style_segment_ranges(elements_by_range)
          elements_by_range.each do |range, elements|
            style = calculate_style(elements)
            segment_ranges(range).each do |segment, inner_range|
              segment.set_style(style, inner_range)
            end
          end
        end

        def calculate_style(elements)
          elements.inject(default_text_styles) do |current_style, element|
            if element.respond_to?(:style)
              TextStyleFactory.apply_styles(current_style, element.style)
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
                element.gui.create_links_in(segment_ranges(range))
              end
            end
          end
        end

        def supports_links?(element)
          element.respond_to?(:gui) &&
            element.gui &&
            element.gui.respond_to?(:create_links_in)
        end

        def segment_at_text_position(index)
          return @segments.last if index < 0
          segment_ranges(index..index).first.first
        end

        # If we've got segments that style us across different ranges, it might
        # be in either, or both, of the segments. This method figures out which
        # segments apply, and what the relative ranges within each segment to use.
        def segment_ranges(text_range)
          return [] unless text_range.any?

          first_text = @segments.first.text
          slice = first_text[text_range]

          if slice.nil? || slice.empty?
            results_in_last_segment(text_range, first_text)
          elsif slice.length < text_range.count
            results_spanning_segments(text_range, first_text, slice)
          else
            results_in_first_segment(text_range)
          end
        end

        def results_in_first_segment(text_range)
          [[@segments.first, text_range]]
        end

        def results_spanning_segments(text_range, first_text, slice)
          result = []
          result << [@segments.first, (text_range.first..first_text.length)]
          # If first == last, then requested range was longer than our one and
          # only segment, so just stick with full range of the first segment.
          if @segments.first != @segments.last
            result << [@segments.last,  (0..text_range.count - slice.length - 1)]
          end
          result
        end

        def results_in_last_segment(text_range, first_text)
          range_start = text_range.first - first_text.length
          range_end   = text_range.last - first_text.length
          [[@segments.last, (range_start..range_end)]]
        end

        # Returns the relative position within the appropriate segment for index
        # in the overall DSL text
        def relative_text_position(index)
          if at_end?(index)
            relative_end_position
          elsif relative_in_first_segment?(index)
            relative_in_first_segment(index)
          else
            relative_in_last_segment(index)
          end
        end

        def relative_in_first_segment?(index)
          index >= 0 &&
            (@segments.one? || index < @segments.first.text.length)
        end

        def at_end?(index)
          index < 0 || index > @dsl.text.length
        end

        def relative_end_position
          @segments.last.text.length
        end

        def relative_in_first_segment(index)
          index
        end

        def relative_in_last_segment(index)
          index - @segments.first.text.length
        end

        # This could be smarter, basing height on the actual line the cursor's
        # in. For now, just use the first line's height.
        def cursor_height
          @segments.first.line_bounds(0).height
        end
      end
    end
  end
end
