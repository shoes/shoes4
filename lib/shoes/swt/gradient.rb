require 'shoes/swt/color'

module Shoes
  module Swt
    class Gradient
      def initialize(dsl)
        @dsl = dsl
      end

      def color1
        @color1 ||= Color.create @dsl.color1
      end

      def color2
        @color2 ||= Color.create @dsl.color2
      end

      def alpha
        @dsl.alpha
      end

      def apply_as_fill(gc)
        gc.set_background color2.real
        gc.set_foreground color1.real
        gc.set_alpha alpha
      end

      def apply_as_stroke(gc)
        gc.set_foreground color1.real
        gc.set_alpha alpha
      end
    end
  end
end
