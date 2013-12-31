class Shoes
  module Swt
    class TextBlock
      include Common::Clear
      include Common::Toggle
      include Common::Clickable
      include ::Shoes::BackendDimensionsDelegations

      DEFAULT_SPACING = 4

      attr_reader :dsl, :app
      attr_accessor :fitted_layouts

      def initialize(dsl)
        @dsl = dsl
        @app = dsl.app.gui
        @opts = @dsl.opts
        @painter = TextBlockPainter.new @dsl
        @app.add_paint_listener @painter
      end

      def redraw
        app.redraw
      end

      def update_position
        redraw
      end

      def get_height
        get_size.last
      end

      def get_size
        # TODO: This isn't right, but this gets called by the DSL early before
        # we've actually fitted. We have to respond with something, but until
        # contents_alignment, we don't actually know our size.
        #
        # A better solution would probably be having contents_alignment write
        # back to the DSL instead and making sure the early load cases can
        # handle not having the values before we've positioned thing.
        #
        # Additionally, the sizing applied in the DSL doesn't factor in any
        # explicitly set values for height/width.
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
        layout.bounds.width <= width
      end

      def contents_alignment(current_position)
        fitter = ::Shoes::Swt::TextBlockFitter.new(self, current_position)
        @fitted_layouts = fitter.fit_it_in

        if fitted_layouts.one?
          set_absolutes_for_one_layout(current_position)
        else
          set_absolutes_for_two_layouts(current_position)
        end

        if current_position.moving_next || trailing_newline?
          bump_absolutes_to_next_line
        end
      end

      def first_layout
        fitted_layouts.first.layout
      end

      def last_layout
        fitted_layouts.last.layout
      end

      def last_bounds
        line_count = last_layout.line_count
        last_layout.get_line_bounds(line_count - 1)
      end

      def layout_height(layout)
        layout.bounds.height - layout.spacing
      end

      def line_height(layout)
        layout.line_metrics(layout.line_count - 1).height
      end

      def trailing_newline?
        last_layout.text.end_with?("\n")
      end

      def set_absolutes_for_one_layout(current_position)
        @dsl.absolute_right = @dsl.absolute_left + last_bounds.width
        @dsl.absolute_bottom = current_position.y + layout_height(first_layout)
        @dsl.absolute_top = @dsl.absolute_bottom - line_height(first_layout)
      end

      def set_absolutes_for_two_layouts(current_position)
        @dsl.absolute_right =  @dsl.parent.absolute_left + last_bounds.width
        @dsl.absolute_bottom = current_position.next_line_start + layout_height(last_layout)
        @dsl.absolute_top = @dsl.absolute_bottom - line_height(last_layout)
      end

      def bump_absolutes_to_next_line
        @dsl.absolute_right = @dsl.parent.absolute_left
        @dsl.absolute_top = @dsl.absolute_bottom
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
          app.clickable_elements.delete link
          ln = link.click_listener
          app.remove_listener ::Swt::SWT::MouseDown, ln if ln
          app.remove_listener ::Swt::SWT::MouseUp, ln if ln
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
