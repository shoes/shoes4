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

      def apply_as_fill(gc, left, top, width, height, angle = 0)
        l, t, w, h, a = *pattern_pos(left, top, width, height, -angle)
        pattern = ::Swt::Pattern.new Shoes.display, l, t, w, h, color1.real, color2.real
        gc.set_background_pattern pattern
      end

      def apply_as_stroke(gc)
        gc.set_foreground color1.real
        gc.set_alpha alpha
      end

      def pattern_pos left, top, w, h, a
        w, h = w*0.5, h*0.5
        a = Math::PI*(a/180.0)
        a = a % (Math::PI*2.0)
        cal = proc do
          l = Math.sqrt(w**2 + h**2)
          b = (h==0 and w==0) ? h/w : Math.atan(h/w)
          c = Math::PI*0.5 - a - b
          r = l * Math.cos(c.abs)
          [r * Math.cos(b+c), r * Math.sin(b+c)]
        end
        if 0 <= a and a < Math::PI*0.5
          x, y = cal.call
         [left+w+x, top+h-y, left+w-x, top+h+y]
        elsif Math::PI*0.5 <= a and a < Math::PI
          a -= Math::PI*0.5
          w, h = h, w
          x, y = cal.call
          [left+h+y, top+w+x, left+h-y, top+w-x]
        elsif Math::PI <= a and a < Math::PI*1.5
          a -= Math::PI
          x, y = cal.call
          [left+w-x, top+h+y, left+w+x, top+h-y]
        elsif Math::PI*1.5 <= a and a < Math::PI*2.0
          a -= Math::PI*1.5
          w, h = h, w
          x, y = cal.call
          [left+h-y, top+w-x, left+h+y, top+w+x]
        end
      end
    end
  end
end
