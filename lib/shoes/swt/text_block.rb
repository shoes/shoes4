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
        @dsl            = dsl
        @app            = dsl.app.gui
        @opts           = @dsl.opts
        @fitted_layouts = []
        @painter        = TextBlockPainter.new @dsl
        @app.add_paint_listener @painter
      end

      def dispose
        @fitted_layouts.map &:dispose
      end

      # has a painter, nothing to do
      def update_position
      end

      def in_bounds?(x, y)
        fitted_layouts.any? do |fitted|
          fitted.in_bounds?(x, y)
        end
      end

      # Resources created here need to be disposed (see #dispose). Note that
      # this applies to the ::Swt::Font object and the ::Swt::TextLayout
      # object. The ::Swt::TextStyle object does not need to be disposed,
      # because it is not backed by system resources. This is tracked via the
      # use of the instance factories on the FittedTextLayout, which gets
      # disposed of properly by the TextBlock and TextBlockFitter code.
      #
      # This method is only called by TextBlockFitter, and then only from
      # #contents_alignment, so any layouts generated here end up in
      # @fitted_layouts
      def generate_layout(width, text)
        layout = ::Swt::TextLayout.new Shoes.display
        fitted = FittedTextLayout.new(layout)

        font = fitted.font_factory.create_font(name: @dsl.font,
                                           size: @dsl.font_size,
                                           styles:[::Swt::SWT::NORMAL])
        style = fitted.style_factory.create_style(font, nil, nil, {})

        layout.setText text
        layout.setSpacing(@opts[:leading] || DEFAULT_SPACING)
        layout.setStyle style, 0, text.length - 1
        shrink_layout_to(layout, width) unless layout_fits_in?(layout, width)

        fitted
      end

      def shrink_layout_to(layout, width)
        layout.setWidth(width)
      end

      def layout_fits_in?(layout, width)
        layout.bounds.width <= width
      end

      def contents_alignment(current_position)
        dispose_existing_layouts
        @fitted_layouts = TextBlockFitter.new(self, current_position).fit_it_in

        if fitted_layouts.one?
          set_absolutes_for_one_layout
        else
          set_absolutes_for_two_layouts(current_position.next_line_start)
        end

        if trailing_newline?
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

      def set_absolutes_for_one_layout
        @dsl.absolute_right = @dsl.absolute_left + last_bounds.width + margin_right
        @dsl.absolute_bottom = @dsl.absolute_top + layout_height(first_layout) +
                                margin_top + margin_bottom
        @dsl.absolute_top = @dsl.absolute_bottom - line_height(first_layout)
        @dsl.calculated_width = first_layout.bounds.width
      end

      def set_absolutes_for_two_layouts(next_line_start)
        @dsl.absolute_right =  @dsl.parent.absolute_left + last_bounds.width + margin_right
        @dsl.absolute_bottom = next_line_start + layout_height(last_layout) +
                                margin_top + margin_bottom
        @dsl.absolute_top = @dsl.absolute_bottom - line_height(last_layout)
        @dsl.calculated_width = last_layout.bounds.width
      end

      def bump_absolutes_to_next_line
        @dsl.absolute_right = @dsl.parent.absolute_left
        @dsl.absolute_top = @dsl.absolute_bottom
      end

      def clear
        super
        clear_contents
      end

      def replace(*values)
        clear_contents
        @dsl.update_text_styles(values)
      end

      private

      def clear_contents
        dispose_existing_layouts
        clear_links
      end

      def clear_links
        @dsl.links.each(&:clear)
      end

      def dispose_existing_layouts
        @fitted_layouts.map(&:dispose)
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
