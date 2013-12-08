require 'shoes/swt/text_block_fitter'

class Shoes
  module Swt
    class TextBlock
      include Common::Clear
      include Common::Toggle
      include ::Shoes::BackendDimensionsDelegations

      DEFAULT_SPACING = 4

      attr_reader :dsl

      def initialize(dsl)
        @dsl = dsl
        @opts = dsl.opts
        @container = @dsl.app.gui.real
        @painter = TextBlockPainter.new @dsl
        @container.add_paint_listener @painter
      end

      def redraw
        @container.redraw unless @container.disposed?
      end

      def update_position
        redraw
      end

      def get_height
        text_layout, font = set_styles
        text_layout.width = @dsl.element_width
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
        font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size,
                               ::Swt::SWT::NORMAL
        style = ::Swt::TextStyle.new font, nil, nil
        text_layout.setStyle style, 0, @dsl.text.length - 1
        return text_layout, font
      end

      def generate_layout(width, text)
        layout = ::Swt::TextLayout.new Shoes.display
        layout.setText text
        layout.setSpacing(@opts[:leading] || DEFAULT_SPACING)
        font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size, ::Swt::SWT::NORMAL
        style = ::Swt::TextStyle.new font, nil, nil
        layout.setStyle style, 0, text.length - 1
        shrink_layout_to(layout, width) unless layout_fits_in?(layout, width)

        layout
      end

      def shrink_layout_to(layout, width)
        layout.setWidth(width)
      end

      def layout_fits_in?(layout, width)
        layout.get_bounds.width <= width
      end

      def move_current_position(current_position)
        fitter = ::Shoes::Swt::TextBlockFitter.new(self)
        fitted_layouts = fitter.fit_it_in

        return if fitted_layouts.empty?

        last_fitted = fitted_layouts.last
        last_layout = last_fitted.layout
        line_count = last_layout.line_count
        last_bounds = last_layout.get_line_bounds(line_count - 1)

        if fitted_layouts.size == 1
          current_position.x = @dsl.absolute_left + last_bounds.width
          current_position.y = @dsl.absolute_top
        else
          current_position.x = last_bounds.width
          current_position.y = last_layout.get_bounds.height
        end
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
          @dsl.element_width, @dsl.element_height = get_size
        end
        @dsl.update_text_styles(values)
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
