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

        font = ::Swt::Graphics::Font.new Shoes.display, name, size, styles
        @fonts << font
        font
      end

      def dispose
        @fonts.each { |font| font.dispose unless font.disposed? }
      end
    end
  end
end
