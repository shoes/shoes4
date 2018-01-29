# frozen_string_literal: true

class Shoes
  module DSL
    module Style
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

      # Each value is a top-level Shoes DSL method overriding the default
      # styling of following elements.
      PATTERN_APP_STYLES = [:fill, :stroke].freeze

      # Each value is a top-level Shoes DSL method overriding the default
      # styling of following elements.
      OTHER_APP_STYLES = [:cap, :rotate, :strokewidth, :transform].freeze

      PATTERN_APP_STYLES.each do |style|
        define_method style do |val|
          @__app__.remove_styles.delete(style)
          @__app__.style[style] = pattern(val)
        end
      end

      OTHER_APP_STYLES.each do |style|
        define_method style do |val|
          @__app__.style[style] = val
        end
      end

      def translate(left, top)
        @__app__.style[:translate] = [left, top]
      end

      def nostroke
        @__app__.remove_styles << :stroke
        @__app__.style[:stroke] = nil
      end

      def nofill
        @__app__.remove_styles << :fill
        @__app__.style[:fill] = nil
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
