module Shoes
  module Swt
    module Color
      def to_native
        ::Swt::Graphics::Color.new(Shoes.display, @red, @green, @blue)
      end
    end
  end
end

module Shoes
  class Color
    include Shoes::Swt::Color
  end
end
