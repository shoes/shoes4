require 'shoes/swt/text_block_fitter'

class Shoes
  module Swt
    class TextBlock
      include Common::Clear
      include Common::Toggle
      include ::Shoes::BackendDimensionsDelegations

      DEFAULT_SPACING = 4

      attr_reader :dsl
      attr_accessor :fitted_layouts

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
        get_size.last
      end

      def get_size
        # TODO: This isn't quite right, but this gets called by the DSL early
        # on before we've actually fitted.
        #
        # Should contents_alignment instead write back to the DSL on fitting?
        text_layout = generate_layout(nil, @dsl.text)
        bounds = text_layout.bounds
        return bounds.width, bounds.height
      end

      def generate_layout(width, text)
        layout = ::Swt::TextLayout.new Shoes.display
        layout.setText text
        layout.setSpacing(@opts[:leading] || DEFAULT_SPACING)
        font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size,
                               ::Swt::SWT::NORMAL
        style = ::Swt::TextStyle.new font, nil, nil
        layout.setStyle style, 0, text.length - 1
        shrink_layout_to(layout, width) if width && !layout_fits_in?(layout, width)

        layout
      end

      def shrink_layout_to(layout, width)
        layout.setWidth(width)
      end

      def layout_fits_in?(layout, width)
        layout.get_bounds.width <= width
      end

      def contents_alignment(current_position)
        fitter = ::Shoes::Swt::TextBlockFitter.new(self, current_position)
        @fitted_layouts = fitter.fit_it_in

        # TODO: Should this also reassign the DSL sizes instead of the DSL
        # trying to read (prematurely?) from the @gui?
        if fitted_layouts.size == 1
          set_absolutes_for_one_layout
        else
          set_absolutes_for_two_layouts(current_position)
        end
      end

      def last_layout
        fitted_layouts.last.layout
      end

      def last_bounds
        line_count = last_layout.line_count
        last_bounds = last_layout.get_line_bounds(line_count - 1)
      end

      def set_absolutes_for_one_layout
        @dsl.absolute_right = @dsl.absolute_left + last_bounds.width
      end

      def set_absolutes_for_two_layouts(current_position)
        @dsl.absolute_right =  @dsl.parent.absolute_left + last_bounds.width

        layout = last_layout
        last_line_height = layout.line_metrics(layout.line_count - 1).height
        layout_height = layout.get_bounds.height - (layout.spacing * 2)
        @dsl.absolute_top = current_position.max_bottom + layout_height - last_line_height
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
