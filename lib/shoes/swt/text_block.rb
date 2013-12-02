require 'shoes/swt/text_block_fitter'

class Shoes
  module Swt
    class TextBlock
      include Common::Clear
      include Common::Toggle
      include ::Shoes::BackendDimensionsDelegations

      DEFAULT_SPACING = 4

      attr_reader :dsl

      def initialize(dsl, opts = nil)
        @dsl = dsl
        @opts = opts
        @container = @dsl.app.gui.real
        @painter = TextBlockPainter.new @dsl, self, opts
        @container.add_paint_listener @painter
      end

      def redraw
        @container.redraw
      end

      def move x, y
        redraw unless @container.disposed?
      end

      def get_height
        text_layout, font = set_styles
        text_layout.width = @dsl.width
        text_layout.getBounds(0, @dsl.text.length - 1).height.tap{font.dispose}
      end

      def get_size
        text_layout, font = set_styles
        bounds = text_layout.getBounds(0, @dsl.text.length - 1)
        font.dispose
        return bounds.width, bounds.height
      end

      def set_styles
        text_layout = ::Swt::TextLayout.new Shoes.display
        text_layout.setText @dsl.text
        text_layout.setSpacing(@opts[:leading] || DEFAULT_SPACING)
        font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size, ::Swt::SWT::NORMAL
        style = ::Swt::TextStyle.new font, nil, nil
        text_layout.setStyle style, 0, @dsl.text.length - 1
        return text_layout, font
      end

      def generate_layout(width, text)
        text_layout = ::Swt::TextLayout.new Shoes.display
        text_layout.setText text
        text_layout.setSpacing(@opts[:leading] || DEFAULT_SPACING)
        font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size, ::Swt::SWT::NORMAL
        style = ::Swt::TextStyle.new font, nil, nil
        text_layout.setStyle style, 0, text.length - 1

        # Apply maximum width to wrap if we've exceeded our alotted space
        # If we haven't, just leave it with the natural width it consumes
        text_layout.setWidth(width) if text_layout.get_bounds.width > width

        return text_layout
      end

      def contents_alignment
        fitter = ::Shoes::Swt::TextBlockFitter.new(self)
        layouts = fitter.fit_it_in

        return if layouts.empty?

        # TODO: Should this take value from right-most layout?
        @dsl.absolute_right = @dsl.absolute_left + layouts.first.get_bounds.width
      end

      def clear
        super
        clear_links
      end

      def replace *values
        clear_links
        # TODO We should never use instance_variable_set rather an accessor
        @dsl.instance_variable_set :@text, values.map(&:to_s).join
        if @dsl.text.length > 1
          @dsl.width, @dsl.height = get_size
        end
        @opts[:text_styles] = @dsl.app.gather_text_styles(values)
        redraw
      end

      def contents
      end


      private

      def clear_links
        @dsl.links.each do |link|
          @dsl.app.gui.clickable_elements.delete link
          ln = link.click_listener
          @container.remove_listener ::Swt::SWT::MouseDown, ln if ln
          @container.remove_listener ::Swt::SWT::MouseUp, ln if ln
        end
        @dsl.links.clear
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
