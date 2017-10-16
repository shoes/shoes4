# frozen_string_literal: true
#
# Gradients are a little confusing, but don't let all the math below scare you.
# Here's the (relatively) simple explanation of what's going on.
#
# ::SWT::Pattern, the underlying class we use, defines a gradient by a starting
# and ending point. We account the angle into it by changing these points.
#
# To look right, the start/end points must be outside our shape! If not, then
# we get a hard line where the color resets without fading, which looks bad.
# Given that, we must keep those points outside our bounds of the element,
# which are reported via the redraw_left, redraw_top, etc. methods.
#
class Shoes
  module Swt
    class Gradient
      include Common::Remove

      def initialize(dsl)
        @dsl = dsl
        @patterns = []
      end

      def dispose
        @color1&.dispose
        @color2&.dispose

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

      def apply_as_fill(gc, dsl)
        pattern = create_pattern(dsl)
        gc.set_background_pattern pattern
      end

      def apply_as_stroke(gc, dsl)
        pattern = create_pattern(dsl)
        gc.set_foreground_pattern pattern
      end

      private

      def create_pattern(gui)
        dsl    = gui.dsl
        width  = dsl.redraw_width * 0.5
        height = dsl.redraw_height * 0.5
        angle  = normalize_angle(-(dsl.angle || 0))
        left, top, width, height = determine_args_based_on_angle(angle,
                                                                 dsl.redraw_left,
                                                                 dsl.redraw_top,
                                                                 width,
                                                                 height)

        pattern = ::Swt::Pattern.new Shoes.display, left, top, width, height,
                                     color1.real, color2.real
        @patterns << pattern
        pattern
      end

      def normalize_angle(angle)
        angle = Math::PI * (angle / 180.0)
        angle % (Math::PI * 2.0)
      end

      def determine_args_based_on_angle(angle, left, top, width, height)
        x, y = calculate_x_and_y(angle, height, width)
        if angle >= 0 && angle < Math::PI * 0.5
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
        b      = my_height.zero? && my_width.zero? ? 0 : Math.atan(my_height / my_width)
        c      = Math::PI * 0.5 - my_angle - b
        r      = length * Math.cos(c.abs)
        x      = r * Math.cos(b + c)
        y      = r * Math.sin(b + c)
        [x, y]
      end
    end
  end
end
