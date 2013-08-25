class Shoes
  module Mock
    class TextBlock
      include Shoes::Mock::CommonMethods
      HEIGHT = 10

      def initialize(dsl, opts = nil)
        @dsl = dsl
        @opts = opts
      end
      def get_size(*opts); end
      def get_height
        HEIGHT
      end
      def redraw(*opts); end
      def replace *opts
        @dsl.instance_variable_set :@text, opts.map(&:to_s).join
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
