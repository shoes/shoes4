class Shoes
  module Swt
    class TextFont
      attr_reader :display, :font_style, :font

      def initialize(display, font_style)
        @display = display
        @font_style = font_style
      end

      def ==(other_font)
        [@display, @font_style] == [other_font.display, other_font.font_style]
      end

      def make_font()
        name = @font_style[:name]
        size = @font_style[:size]
        styles = @font_style[:styles].reduce { |result, s| result | s }
        @font = ::Swt::Graphics::Font.new @display, name, size, styles
        self
      end
    end
  end
end
