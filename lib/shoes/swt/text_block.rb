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
        dispose_existing_layouts
      end

      # has a painter, nothing to do
      def update_position
      end

      def in_bounds?(x, y)
        fitted_layouts.any? do |fitted|
          fitted.in_bounds?(x, y)
        end
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

        @dsl.calculated_width = @fitted_layouts.last.width
        @dsl.calculated_height = @fitted_layouts.inject(0) do |total, layout|
          total += layout.bounds.height
        end
      end

      def layout_height
        fitted_layouts.last.layout_height
      end

      def last_line_width
        fitted_layouts.last.last_line_width
      end

      def last_line_height
        fitted_layouts.last.last_line_height
      end

      def trailing_newline?
        @dsl.text.end_with?("\n")
      end

      def set_absolutes_for_one_layout
        @dsl.absolute_right = @dsl.absolute_left + last_line_width + margin_right
        @dsl.absolute_bottom = @dsl.absolute_top + layout_height +
                                margin_top + margin_bottom
        @dsl.absolute_top = @dsl.absolute_bottom - last_line_height
      end

      def set_absolutes_for_two_layouts(next_line_start)
        @dsl.absolute_right =  @dsl.parent.absolute_left + last_line_width + margin_right
        @dsl.absolute_bottom = next_line_start + layout_height +
                                margin_top + margin_bottom
        @dsl.absolute_top = @dsl.absolute_bottom - last_line_height
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
        @fitted_layouts.clear
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
