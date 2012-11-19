require 'shoes/swt/color'

module Shoes
  module Swt
    class Gradient
      def initialize(dsl)
        @dsl = dsl
      end

      def color1
        Color.create @dsl.color1
      end

      def color2
        Color.create @dsl.color2
      end

      def alpha
        @dsl.alpha
      end

      def apply_as_fill(gc)
        gc.set_background color1
        gc.set_foreground color2
        gc.set_alpha alpha
      end

      def apply_as_stroke(gc)
        # TODO: implement!
      end
    end
  end
end
