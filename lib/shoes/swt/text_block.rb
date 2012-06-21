module Shoes
  module Swt
    module Text_block
      DEFAULT_TEXTBLOCK_FONT = ["Arial"]

      def gui_textblock_init
        self.gui_element = st = ::Swt::Custom::StyledText.new(self.gui_container, 
          ::Swt::SWT::WRAP)

        st.set_editable false
        st.set_caret nil 
               
        gui_set_font        
        gui_update_text
      end

      def gui_update_text
        self.gui_element.set_text @text
      end

      def gui_set_font(font_family=DEFAULT_TEXTBLOCK_FONT, 
                       style_options=[], font_size=self.font_size)
        styled_text = self.gui_element
        
        @font_size = font_size unless font_size.nil?

        font_options = ::Swt::SWT::NORMAL
        font_options = ::Swt::SWT::ITALIC if style_options.member? :italic
        font_options = ::Swt::SWT::BOLD if style_options.member? :bold
        
        @font = font_family.first unless font_family.nil?

        swt_font = ::Swt::Graphics::Font.new(self.gui_container.get_display,
          @font, self.font_size, font_options)
        styled_text.set_font swt_font
      end

      def move(left, top)
        super left, top
        unless gui_element.disposed?
          if gui_container.get_layout
            old_gui_container = self.gui_container
            self.gui_container = ::Swt::Widgets::Composite.new(@app.gui_container, 
              ::Swt::SWT::NO_BACKGROUND)
            self.gui_element.dispose
            self.gui_container.set_layout nil
            self.gui_element = ::Swt::Custom::StyledText.new(gui_container,
              ::Swt::SWT::PUSH).tap do |text_block|
              text_block.set_text @text
              text_block.pack 
              # todo more..
            end
            self.gui_container.set_bounds(0, 0, @app.gui_container.size.x, 
              @app.gui_container.size.y)
            self.gui_container.move_above old_gui_container
            old_gui_container.layout
          end
          self.gui_element.set_location left, top
          self.gui_element.redraw
        end        
      end

    end
  end
end

module Shoes
  class Text_block
    include Shoes::Swt::Text_block
  end
end
