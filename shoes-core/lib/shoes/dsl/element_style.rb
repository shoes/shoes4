# frozen_string_literal: true
class Shoes
  module DSL
    module ElementStyle
      # Set default style for elements of a particular class, or for all
      # elements, or return the current defaults for all elements
      #
      # @overload style(klass, styles)
      #   Set default style for elements of a particular class
      #   @param [Class] klass a Shoes element class
      #   @param [Hash] styles default styles for elements of klass
      #   @example
      #     style Para, :text_size => 42, :stroke => green
      #
      # @overload style(styles)
      # Set default style for all elements
      #   @param [Hash] styles default style for all elements
      #   @example
      #     style :stroke => alicewhite, :fill => black
      #
      # @overload style()
      #   @return [Hash] the default style for all elements
      def style(klass_or_styles = nil, styles = {})
        if klass_or_styles.kind_of? Class
          klass = klass_or_styles
          @__app__.element_styles[klass] = styles
        else
          @__app__.style(klass_or_styles)
        end
      end

      private

      def style_normalizer
        @style_normalizer ||= Common::StyleNormalizer.new
      end

      def pop_style(opts)
        opts.last.class == Hash ? opts.pop : {}
      end

      # Default styles for elements of klass
      def style_for_element(klass, styles = {})
        @__app__.element_styles.fetch(klass, {}).merge(styles)
      end

      def normalize_style_for_element(clazz, texts)
        style = style_normalizer.normalize(pop_style(texts))
        style_for_element(clazz, style)
      end
    end
  end
end
