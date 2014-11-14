class Shoes
  module Swt
    class TextFontFactory
      def initialize
        @fonts = []
      end

      def create_font(font_style)
        name = font_style[:name]
        size = font_style[:size]
        styles = styles_bitmask(font_style[:styles])

        existing_font = find_existing_font(name, size, styles)
        if existing_font
          existing_font
        else
          build_font(name, size, styles)
        end
      end

      def dispose
        @fonts.each { |font| font.dispose unless font.disposed? }
        @fonts.clear
      end

      def find_existing_font(name, size, styles)
        # Bit odd, but fonts on some OS's have multiple font_data elements,
        # so check if any of them match.
        @fonts.find do |font|
          font.font_data.any? do |font_data|
            font_data.name == name &&
              # Windows seems to create fonts of height 15.75 when requesting 16
              font_data.height.round == size.round &&
              font_data.style == styles
          end
        end
      end

      def build_font(name, size, styles)
        font = ::Swt::Graphics::Font.new @display, name, size, styles
        @fonts << font
        font
      end

      def styles_bitmask(styles)
        styles.reduce { |result, s| result | s }
      end
    end
  end
end
