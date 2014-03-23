class Shoes
  module Mock
    class TextBlock
      include Shoes::Mock::CommonMethods

      def initialize(dsl, opts = nil)
        @dsl = dsl
        @opts = opts
      end

      def redraw(*opts); end

      def replace(*opts)
      end

      def clear;end

      def contents_alignment(*args);end
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
