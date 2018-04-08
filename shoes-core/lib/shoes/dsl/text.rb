# frozen_string_literal: true

class Shoes
  module DSL
    # DSL methods for displaying text in Shoes applications
    #
    # @see Shoes::DSL
    module Text
      # @!method banner(text = '', opts = {})
      # Large banner sized text block.
      # @param [String, Array<String>] text string or array of strings to show
      # @param [Hash] opts
      # @return [Shoes::Banner]

      # @!method title(text = '', opts = {})
      # Title sized text block.
      # @param [String, Array<String>] text string or array of strings to show
      # @param [Hash] opts
      # @return [Shoes::Title]

      # @!method subtitle(text = '', opts = {})
      # Subtitle sized text block.
      # @param [String, Array<String>] text string or array of strings to show
      # @param [Hash] opts
      # @return [Shoes::Subtitle]

      # @!method tagline(text = '', opts = {})
      # Tagline sized text block.
      # @param [String, Array<String>] text string or array of strings to show
      # @param [Hash] opts
      # @return [Shoes::Tagline]

      # @!method caption(text = '', opts = {})
      # Caption sized text block.
      # @param [String, Array<String>] text string or array of strings to show
      # @param [Hash] opts
      # @return [Shoes::Caption]

      # @!method para(text = '', opts = {})
      # Paragraph sized text block.
      # @param [String, Array<String>] text string or array of strings to show
      # @param [Hash] opts
      # @return [Shoes::Para]

      # @!method inscription(text = '', opts = {})
      # Small, inscription sized text block.
      # @param [String, Array<String>] text string or array of strings to show
      # @param [Hash] opts
      # @return [Shoes::Inscription]
      %w[banner title subtitle tagline caption para inscription].each do |method|
        define_method method do |*texts|
          styles = pop_style(texts)
          klass = Shoes.const_get(method.capitalize)
          create klass, texts, styles
        end
      end

      # @!method code(text = '')
      # Displays with in a monospaced font. Intended to be called within another text block.
      # @example
      #   para code('goto 10')
      #
      # @return [Shoes::Span]

      # @!method del(text = '')
      # Displays with strikethrough. Intended to be called within another text block.
      # @example
      #   para del('nope')
      #
      # @return [Shoes::Span]

      # @!method em(text = '')
      # Displays emphasized text. Intended to be called within another text block.
      # @example
      #   para em('EMPHASIS')
      #
      # @return [Shoes::Span]

      # @!method ins(text = '')
      # Displays underlined. Intended to be called within another text block.
      # @example
      #   para ins('such lines, very wow')
      #
      # @return [Shoes::Span]

      # @!method sub(text = '')
      # Displays as subscript. Intended to be called within another text block.
      # @example
      #   para sub('down here')
      #
      # @return [Shoes::Span]

      # @!method sup(text = '')
      # Displays as superscript. Intended to be called within another text block.
      # @example
      #   para '2', sup('^1')
      #
      # @return [Shoes::Span]

      # @!method strong(text = '')
      # Displays bolded text. Intended to be called within another text block.
      # @example
      #   para strong('TEXT')
      #
      # @return [Shoes::Span]

      # @private
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

      # Displays text in different foreground color. Intended to be called within another text block.
      #
      # @example
      #   para fg('2', blue)
      #
      # @return [Shoes::Span]
      def fg(*texts, color)
        Shoes::Span.new texts,  stroke: pattern(color)
      end

      # Displays text in different background color. Intended to be called within another text block.
      #
      # @example
      #   para bg('2', blue)
      #
      # @return [Shoes::Span]
      def bg(*texts, color)
        Shoes::Span.new texts,  fill: pattern(color)
      end

      # Displays a link within a text block. Intended to be called within another text block.
      #
      # @overload link(*texts, opts, &blk)
      #   @param [String, Array<String>] texts string or array of strings to show
      #   @param [Hash] opts styling options
      #   @param [Proc] blk behavior on link click
      #   @option [Proc, String] :click code to execute, or url to visit
      #
      #   @example
      #     para link('clicky') { alert('clicked') }
      #
      #   @return [Shoes::Span]
      def link(*texts, &blk)
        opts = normalize_style_for_element(Shoes::Link, texts)
        Shoes::Link.new @__app__, texts, opts, blk
      end

      # Displays a subsection of text within a larger text block.
      # Intended to be called within another text block to apply styling.
      #
      # @overload span(*texts, opts)
      #   @param [String, Array<String>] texts string or array of strings to show
      #   @param [Hash] opts styling options
      #
      #   @example
      #     para span('spanner')
      #
      #   @return [Shoes::Span]
      def span(*texts)
        opts = normalize_style_for_element(Shoes::Span, texts)
        Shoes::Span.new texts, opts
      end
    end
  end
end
