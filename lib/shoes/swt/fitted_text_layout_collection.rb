class Shoes
  module Swt
    class FittedTextLayoutCollection
      extend Forwardable
      def_delegators :@layouts, :length

      attr_reader :default_text_styles

      def initialize(layouts, default_text_styles)
        @layouts = layouts
        @default_text_styles = default_text_styles
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

      def style_segment_ranges(styles_by_range)
        styles_by_range.each do |range, styles|
          style = calculate_style(styles)
          layout_ranges(range).each do |layout, inner_range|
            layout.set_style(style, inner_range)
          end
        end
      end

      def calculate_style(styles)
        styles.inject(default_text_styles) do |current_style, style|
          if style.respond_to?(:opts)
            TextStyleFactory.apply_styles(current_style, style.opts)
          else
            # Didn't know how to style from the element, so punt
            current_style
          end
        end
      end

      # If we've got segments that style us across different ranges, it might
      # be in either, or both, of the layouts. This method figures out which
      # layouts apply, and what the relative ranges within each layout to use.
      def layout_ranges(text_range)
        result = []
        first_text = @layouts.first.layout.text
        slice = first_text[text_range]
        if slice.nil? || slice.empty?
          result << [@layouts.last,
                     (text_range.first - first_text.length..text_range.last - first_text.length)]
        elsif slice.length < text_range.count
          result << [@layouts.first, (text_range.first..first_text.length)]
          # If first == last, then requested range was longer than our one and
          # only layout, so just stick with full range of the first layout.
          if @layouts.first != @layouts.last
            result << [@layouts.last,  (0..text_range.count - slice.length - 1)]
          end
        else
          result << [@layouts.first, text_range]
        end
        result
      end
    end
  end
end
