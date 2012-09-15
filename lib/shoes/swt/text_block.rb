module Shoes
  module Swt
    class TextBlock
      include Common::Move

      def initialize(dsl, opts = nil)
        @dsl = dsl
        @container = opts[:app].gui.real
        @container.addPaintListener(TbPainter.new(@dsl))
      end

      def move x, y
        @left, @top, @width, @height = @dsl.left, @dsl.top, @dsl.width, @dsl.height
        super
      end
      
      def get_height
        tl, font = set_styles
        tl.setWidth @dsl.width
        tl.getBounds(0, @dsl.text.length - 1).height.tap{font.dispose}
      end
      
      def get_size
        tl, font = set_styles
        gb = tl.getBounds(0, @dsl.text.length - 1).tap{font.dispose}
        return gb.width, gb.height
      end
      
      def set_styles
        tl = ::Swt::TextLayout.new Shoes.display
        tl.setText @dsl.text
        font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size, ::Swt::SWT::NORMAL
        style = ::Swt::TextStyle.new font, nil, nil
        tl.setStyle style, 0, @dsl.text.length - 1
        return tl, font
      end

      private

      class TbPainter
        include Common::Resource

        def initialize(dsl)
          @dsl = dsl
          @tl = ::Swt::TextLayout.new Shoes.display
        end

        def paintControl(paint_event)
          gc = paint_event.gc
          gcs_reset gc
          @tl.setText @dsl.text
          set_styles
          @tl.setWidth @dsl.width
          @tl.draw gc, @dsl.left, @dsl.top
        end
        
        def set_styles
          font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size, ::Swt::SWT::NORMAL
          style = ::Swt::TextStyle.new font, nil, nil
          @tl.setStyle style, 0, @dsl.text.length - 1
          @gcs << font
        end
      end
    end
    
    class Banner < TextBlock; end
    class Title < TextBlock; end
    class Subtitle < TextBlock; end
    class Tagline < TextBlock; end
    class Caption < TextBlock; end
    class Para < TextBlock; end
    class Inscription < TextBlock; end
  end
end
