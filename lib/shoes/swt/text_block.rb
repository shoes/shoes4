module Shoes
  module Swt
    class TextBlock
      include Common::Child

      # Create a list box
      #
      # @param [Shoes::Text_block] dsl The Shoes DSL text box this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk
        @real = st = ::Swt::Custom::StyledText.new(@parent.real,
          ::Swt::SWT::WRAP)
        st.editable = false
        st.caret = nil
        self.set_font
        self.update_text
      end

      def update_text
        @real.set_text @dsl.text
      end

      def set_font(font_family=DEFAULT_TEXTBLOCK_FONT,
                       style_options=[], font_size=@dsl.font_size)
        @dsl.font_size_no_update = font_size unless font_size.nil?

        font_options = ::Swt::SWT::NORMAL
        font_options = ::Swt::SWT::ITALIC if style_options.member? :italic
        font_options = ::Swt::SWT::BOLD if style_options.member? :bold

        @font = font_family.first
        swt_font = ::Swt::Graphics::Font.new(@real.get_display,
          @font, @dsl.font_size, font_options)
        @real.set_font swt_font
      end

      def hidden(hidden)
        @real.visible = (not hidden)
      end
    end
  end
end
