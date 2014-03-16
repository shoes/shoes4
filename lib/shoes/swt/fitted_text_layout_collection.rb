require 'forwardable'

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
          ranges_for(range).each do |layout, inner_range|
            layout.set_style(style, inner_range)
          end
        end
      end

      def calculate_style(styles)
        styles.inject(default_text_styles) do |current_style, style|
          TextStyleFactory.apply_styles(current_style, style.opts)
        end
      end

      # If we've got segments that style us across different ranges, it might
      # be in either, or both, of the layouts. This method figures out which
      # layouts apply, and what the relative ranges within each layout to use.
      def ranges_for(range)
        result = []
        first_text = @layouts.first.layout.text
        slice = first_text[range]
        if slice.nil? || slice.empty?
          result << [@layouts.last,
                     (range.first - first_text.length..range.last - first_text.length)]
        elsif slice.length < range.count
          result << [@layouts.first, (range.first..first_text.length)]
          result << [@layouts.last,  (0..range.count - slice.length - 1)]
        else
          result << [@layouts.first, range]
        end
        result
      end
    end
  end
end
