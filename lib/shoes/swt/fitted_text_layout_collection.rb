require 'forwardable'

class Shoes
  module Swt
    class FittedTextLayoutCollection
      extend Forwardable
      def_delegators :@layouts, :length

      def initialize(layouts)
        @layouts = layouts
      end

      def style_from(default_text_styles, opts)
        @layouts.each do |layout|
          layout.style_from(default_text_styles, opts)
        end
      end

      def draw(graphic_context)
        @layouts.each do |layout|
          layout.draw(graphic_context)
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
