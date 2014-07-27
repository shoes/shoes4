class Shoes
  module Swt
    class TextFontFactory
      def initialize
        @fonts = []
      end

      def create_font(font_style)
        new_font = TextFont.new(Shoes.display, font_style)

        # Check if font with same style and display exists
        existing_font = @fonts.find{ |font| font == new_font }
        return existing_font.font if existing_font

        # Hold a reference to the font so we can dispose it when the time comes
        @fonts << new_font.make_font

        new_font.font
      end

      def dispose
        @fonts.each { |text_font| text_font.font.dispose unless text_font.font.disposed? }
        @fonts.clear
      end
    end
  end
end

