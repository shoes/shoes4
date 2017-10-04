# frozen_string_literal: true
class Shoes
  module DSL
    module Text
      %w(banner title subtitle tagline caption para inscription).each do |method|
        define_method method do |*texts|
          styles = pop_style(texts)
          klass = Shoes.const_get(method.capitalize)
          create klass, texts, styles
        end
      end

      TEXT_STYLES = {
        code: { font: "Lucida Console" },
        del: { strikethrough: true },
        em: { emphasis: true },
        ins: { underline: true },
        sub: { rise: -10, size_modifier: 0.8 },
        sup: { rise: 10, size_modifier: 0.8 },
        strong: { weight: true },
      }.freeze

      TEXT_STYLES.each_key do |method|
        define_method method do |*texts|
          styles = style_normalizer.normalize(pop_style(texts))
          styles = TEXT_STYLES[method].merge(styles)
          Shoes::Span.new texts, styles
        end
      end

      def fg(*texts, color)
        Shoes::Span.new texts,  stroke: pattern(color)
      end

      def bg(*texts, color)
        Shoes::Span.new texts,  fill: pattern(color)
      end

      def link(*texts, &blk)
        opts = normalize_style_for_element(Shoes::Link, texts)
        Shoes::Link.new @__app__, texts, opts, blk
      end

      def span(*texts)
        opts = normalize_style_for_element(Shoes::Span, texts)
        Shoes::Span.new texts, opts
      end
    end
  end
end
