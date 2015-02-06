class Shoes
  module Swt
    class TextBlock
      include Common::Remove
      include Common::Visibility
      include Common::Clickable
      include ::Shoes::BackendDimensionsDelegations

      DEFAULT_SPACING = 4
      NEXT_ELEMENT_OFFSET = 1

      attr_reader :dsl, :app
      attr_accessor :segments

      def initialize(dsl, app)
        @dsl            = dsl
        @app            = app
        @segments       = []
        @painter        = Painter.new @dsl
        @app.add_paint_listener @painter
      end

      def dispose
        dispose_existing_segments
      end

      # has a painter, nothing to do
      def update_position
      end

      def in_bounds?(x, y)
        segments.any? do |segment|
          segment.in_bounds?(x, y)
        end
      end

      def contents_alignment(current_position)
        dispose_existing_segments
        @segments = Fitter.new(self, current_position).fit_it_in

        return if @segments.nil? || @segments.empty?

        set_absolutes_on_dsl(current_position)
        set_calculated_sizes
      end

      def adjust_current_position(current_position)
        current_position.y = @dsl.absolute_bottom + NEXT_ELEMENT_OFFSET

        last_segment = segments.last
        if last_segment && !@bumped_to_next_line
          # Not quite sure why this is necessary. Could be a problem in some
          # other part of positioning, or something about how text layouts
          # actually draw themselves.
          current_position.x -= 1

          current_position.y -= last_segment.last_line_height
        end
      end

      def set_absolutes_on_dsl(current_position)
        if segments.one?
          set_absolutes(@dsl.absolute_left, @dsl.absolute_top)
        else
          set_absolutes(@dsl.parent.absolute_left, current_position.next_line_start)
        end

        if trailing_newline?
          bump_absolutes_to_next_line
        else
          @bumped_to_next_line = false
        end
      end

      def set_absolutes(starting_left, starting_top)
        last_segment = segments.last

        @dsl.absolute_right  = starting_left + last_segment.last_line_width +
          margin_right - NEXT_ELEMENT_OFFSET

        @dsl.absolute_bottom = starting_top + last_segment.height +
          margin_top + margin_bottom - NEXT_ELEMENT_OFFSET
      end

      def bump_absolutes_to_next_line
        @dsl.absolute_right = @dsl.parent.absolute_left
        @bumped_to_next_line = true
      end

      def set_calculated_sizes
        @dsl.calculated_width  = segments.last.width
        @dsl.calculated_height = segments.inject(0) do |total, segment|
          total + segment.bounds.height
        end
      end

      def remove
        super
        clear_contents
      end

      def replace(*_)
        clear_contents
      end

      private

      def clear_contents
        dispose_existing_segments
        clear_links
      end

      def clear_links
        @dsl.links.each(&:remove)
      end

      def dispose_existing_segments
        @segments.map(&:dispose)
        @segments.clear
      end

      def trailing_newline?
        @dsl.text.end_with?("\n")
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
