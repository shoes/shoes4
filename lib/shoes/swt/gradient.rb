class Shoes
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
        pattern = pattern_position(left, top, width, height, -angle)
        gc.set_background_pattern pattern
      end

      def apply_as_stroke(gc, left, top, width, height, angle = 0)
        pattern = pattern_position(left, top, width, height, -angle)
        gc.set_foreground_pattern pattern
      end

      def pattern_position left, top, width, height, angle
        width, height = width*0.5, height*0.5
        angle = Math::PI*(angle/180.0)
        angle = angle % (Math::PI*2.0)
        cal = proc do
          left = Math.sqrt(width**2 + height**2)
          b = (height==0 and width==0) ? height/width : Math.atan(height/width)
          c = Math::PI*0.5 - angle - b
          r = left * Math.cos(c.abs)
          [r * Math.cos(b+c), r * Math.sin(b+c)]
        end
        x, y = cal.call
        if 0 <= angle and angle < Math::PI*0.5
          args = [left+width+x, top+height-y, left+width-x, top+height+y]
        elsif Math::PI*0.5 <= angle and angle < Math::PI
          args = [left+width+y, top+height+x, left+width-y, top+height-x]
        elsif Math::PI <= angle and angle < Math::PI*1.5
          args = [left+width-x, top+height+y, left+width+x, top+height-y]
        elsif Math::PI*1.5 <= angle and angle < Math::PI*2.0
          args = [left+width-y, top+height-x, left+width+y, top+height+x]
        end
        ::Swt::Pattern.new Shoes.display, args[0], args[1], args[2], args[3], color1.real, color2.real
      end
    end
  end
end
