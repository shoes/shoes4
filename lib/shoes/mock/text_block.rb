class Shoes
  module Mock
    class TextBlock
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(dsl, opts = nil)
        @dsl = dsl
        @opts = opts
      end

      def redraw(*_opts); end

      def replace(*_opts)
      end

      def remove; end

      # A very imperfect implementation, but at least it takes up about a line.
      # Needed to spec scrolling behavior
      def contents_alignment(current_position)
        @dsl.absolute_top = current_position.y + (@dsl.size || 12)
      end

      def adjust_current_position(*_args); end
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
