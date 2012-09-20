module Shoes
  module Mock
    class TextBlock
      include Shoes::Mock::CommonMethods

      def initialize(*opts); end
      def get_size(*opts); end
      def redraw(*opts); end
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
