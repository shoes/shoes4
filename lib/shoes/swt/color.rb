module Shoes
  module Swt
    class Color
      # @param [Shoes::Color] color the DSL representation of this color
      def initialize(color)
        @dsl = color
        @real = ::Swt::Graphics::Color.new(Shoes.display, @dsl.red, @dsl.green, @dsl.blue)
        @alpha = color.alpha
      end

      attr_reader :alpha, :dsl, :real

      def apply_as_background(gc)
        gc.set_background real
        gc.set_alpha alpha
      end

      def apply_as_foreground(gc)
        gc.set_foreground real
        gc.set_alpha alpha
      end

      # TODO: Remove
      def red; @real.red; end
      def green; @real.green; end
      def blue; @real.blue; end
    end
  end
end

module Shoes
  class Color
    def to_native
      ::Shoes::Swt::Color.new(self)
    end
  end
end
