class Shoes
  module Swt
    class Gradient
      include Common::Remove

      def initialize(dsl)
        @dsl = dsl
        @patterns = []
      end

      def dispose
        @color1.dispose if @color1
        @color2.dispose if @color2

        @patterns.each do |pattern|
          pattern.dispose unless pattern.disposed?
        end
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
        pattern = create_pattern(left, top, width, height, -angle)
        gc.set_background_pattern pattern
      end

      def apply_as_stroke(gc, left, top, width, height, angle = 0)
        pattern = create_pattern(left, top, width, height, -angle)
        gc.set_foreground_pattern pattern
      end

      private

      def create_pattern(left, top, width, height, angle)
        width  = width * 0.5
        height = height * 0.5
        angle  = normalize_angle(angle)
        left, top, width, height  = determine_args_based_on_angle(angle, left, top, width, height)

        pattern = ::Swt::Pattern.new Shoes.display, left, top, width, height, color1.real, color2.real
        @patterns << pattern
        pattern
      end

      def normalize_angle(angle)
        angle = Math::PI * (angle / 180.0)
        angle % (Math::PI * 2.0)
      end

      def determine_args_based_on_angle(angle, left, top, width, height)
        x, y = calculate_x_and_y(angle, height, width)
        if 0 <= angle && angle < Math::PI * 0.5
          args = [left + width + x, top + height - y, left + width - x, top + height + y]
        elsif Math::PI * 0.5 <= angle && angle < Math::PI
          args = [left + width + y, top + height + x, left + width - y, top + height - x]
        elsif Math::PI <= angle && angle < Math::PI * 1.5
          args = [left + width - x, top + height + y, left + width + x, top + height - y]
        elsif Math::PI * 1.5 <= angle && angle < Math::PI * 2.0
          args = [left + width - y, top + height - x, left + width + y, top + height + x]
        end
        args
      end

      def calculate_x_and_y(angle, height, width)
        if angle % Math::PI >= (Math::PI * 0.5)
          my_width = height
          my_height = width
        else
          my_width = width
          my_height = height
        end
        my_angle = angle % (Math::PI * 0.5)
        length = Math.sqrt(my_width**2 + my_height**2)
        b      = (my_height == 0 && my_width == 0) ? 0 : Math.atan(my_height / my_width)
        c      = Math::PI * 0.5 - my_angle - b
        r      = length * Math.cos(c.abs)
        x      = r * Math.cos(b + c)
        y      = r * Math.sin(b + c)
        [x, y]
      end
    end
  end
end
