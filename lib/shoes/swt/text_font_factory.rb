class Shoes
  module Swt
    module TextFontFactory
      def self.create_font(disposer, font_style)
        name = font_style[:name]
        size = font_style[:size]
        styles = font_style[:styles].reduce { |result, s| result | s }

        disposer.mark_to_dispose(::Swt::Font.new(Shoes.display, name, size, styles))
      end
    end
  end
end
