class Shoes
  module Swt
    class TextFontFactory
      def initialize
        @fonts = []
      end

      def create_font(font_style)
        name = font_style[:name]
        size = font_style[:size]
        styles = font_style[:styles].reduce { |result, s| result | s }

        # Check if this font already exists, use that instead if it does
        for existing_font in @fonts
          if [Shoes.display, name, size, styles] == existing_font[1..@fonts.length]
            return existing_font[0]
          end
        end

        font = ::Swt::Graphics::Font.new Shoes.display, name, size, styles

        # Hold a reference to the font so we can dispose it when the time comes
        @fonts.push([font, Shoes.display, name, size, styles])

        font
      end

      def dispose
        @fonts.each { |font, _, _, _, _| font.dispose unless font.disposed? }
        @fonts.clear
      end
    end
  end
end
