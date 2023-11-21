# frozen_string_literal: true

class Shoes
  # Arc.  A basic element representing a curve of a circle or an oval.
  #
  # @example A simple arc which describes the bottom half of a circle and uses the centered style.
  #   arc 200, 200, 100, 100, 0, Shoes::PI, center: true
  # @example An arc which describes the top half of a circle.
  #   arc 200, 200, 100, 100, Shoes::PI, 0
  # @note Angle is the gradient angle used across all art elements. Angle1/2 are the angles of
  #   the arc itself!
  # @note The angle passed in is measured in Radians starting at 90 degrees or the 3 o'clock position.
  class Arc < Common::ArtElement
    include Math
    # angle is the gradient angle used across all art elements
    # angle1/2 are the angles of the arc itself!
    style_with :angle1, :angle2, :art_styles, :center, :common_styles, :dimensions, :radius, :wedge
    STYLES = { wedge: false, fill: Shoes::COLORS[:black] }.freeze

    def create_dimensions(left, top, width, height, angle1, angle2)
      @style[:angle1] = angle1 || @style[:angle1] || 0
      @style[:angle2] = angle2 || @style[:angle2] || 0

      left   ||= @style[:left] || 0
      top    ||= @style[:top] || 0
      width  ||= @style[:width] || 0
      height ||= @style[:height] || 0

      @dimensions = Dimensions.new parent, left, top, width, height, @style
    end

    def wedge?
      wedge
    end

    # Access the center point of the arc.
    #
    # @return [Shoes::Point] A point at the center of the arc.
    # @example
    #   my_point = my_arc.center_point
    def center_point
      center_x = left + (element_width * 0.5).to_i
      center_y = top + (element_height * 0.5).to_i
      Point.new(center_x, center_y)
    end

    # Set the center point of an arc.
    #
    # @param point [Shoes::Point] the point to set as the center of the arc.
    # @example Set an arc's center point at the [x, y] coordinates [100, 300]
    #   my_arc.center_point = Shoes::Point.new(100, 300)
    def center_point=(point)
      if style[:center]
        self.left = point.x
        self.top = point.y
      else
        self.left = point.x - (width * 0.5).to_i
        self.top = point.y - (height * 0.5).to_i
      end
    end

    def radius_x
      @radius_x ||= width.to_f / 2
    end

    def radius_y
      @radius_y ||= height.to_f / 2
    end

    def middle_x
      @middle_x ||= left + radius_x
    end

    def middle_y
      @middle_y ||= top + radius_y
    end

    def oval_axis_fraction(axis, input, difference = 0)
      (((input - send("middle_#{axis}"))**2).to_f / ((send("radius_#{axis}") - difference)**2))
    end

    def inner_oval_axis_fraction(axis, input)
      oval_axis_fraction(axis, input, inner_oval_difference)
    end

    def inside_oval?(x, y)
      # The following equation (https://math.stackexchange.com/questions/76457/check-if-a-point-is-within-an-ellipse)
      #
      #    (x - h)**2    (y - k)**2
      #     -------    +  -------   <=   1
      #      Rx ** 2      Ry ** 2
      #
      # The above equation determines if a pair of coordinates are located in an oval.
      # Rx = Radius X; Ry = Radius Y; h,k is the origin; x,y are the input coordinate
      (oval_axis_fraction(:x, x) + oval_axis_fraction(:y, y)) <= 1
    end

    def inside_inner_oval?(x, y)
      # For use when style[:fill] is nil, meaning it is just the edge of the arc
      # This uses shared code with #inside_oval? to check if a point is also inside a second smaller oval.
      # The smaller oval signifies the no_fill area of the arc
      x_side = inner_oval_axis_fraction(:x, x)
      y_side = inner_oval_axis_fraction(:y, y)
      x_side + y_side <= 1
    end

    def normalize_angle(input_angle)
      # This fixes angles > 6.283185 and < 0
      input_angle % (Math::PI * 2)
    end

    def adjust_angle(input_angle)
      # Must pad angle, since angles in standard formulas start at different location than in shoes
      adjusted_angle = input_angle + 1.5708

      # Must make angle 0..6.28318
      normalize_angle(adjusted_angle)
    end

    def y_adjust_negative?(input_angle)
      in_first_quater = (0..Shoes::HALF_PI).cover?(input_angle)
      in_last_quarter = ((Shoes::HALF_PI * 3)..Shoes::TWO_PI).cover?(input_angle)
      in_first_quater || in_last_quarter
    end

    def x_adjust_positive?(input_angle)
      (0..Math::PI).cover?(input_angle)
    end

    def y_result_adjustment(input_angle, y_result)
      # This checks which way from center the angle is
      if y_adjust_negative?(input_angle)
        middle_y - y_result
      else
        middle_y + y_result
      end
    end

    def x_result_adjustment(input_angle, x_result)
      # This checks which way from center the angle is
      if x_adjust_positive?(input_angle)
        middle_x + x_result
      else
        middle_x - x_result
      end
    end

    def generate_coordinates(input_angle, x_result, y_result)
      # This turns results on distance from center into actual coordinates
      x_result = x_result_adjustment(input_angle, x_result).round(3)
      y_result = y_result_adjustment(input_angle, y_result).round(3)

      {
        x_value: x_result,
        y_value: y_result
      }
    end

    def tangent_squared(input_angle)
      tan(input_angle)**2
    end

    def angle_base_coords(given_angle)
      # First the angle must be rotated to work with shoes, also be normalized into the 0..2PI range
      modded_angle = adjust_angle(given_angle)

      # https://math.stackexchange.com/questions/22064/calculating-a-point-that-lies-on-an-ellipse-given-an-angle
      # The above link was used in creating the below formula to find the point values from the center

      top_of_equation = (radius_x * radius_y)

      x_result = top_of_equation / (((radius_y**2) + ((radius_x**2) / tangent_squared(modded_angle)))**0.5)
      y_result = top_of_equation / (((radius_x**2) + ((radius_y**2) * tangent_squared(modded_angle)))**0.5)

      # With distance from center for x and y found, we turn that into coordinates:
      generate_coordinates(modded_angle, x_result, y_result)
    end

    # The following angle coordinate methods are to simply clean up code
    def angle1_coordinates
      @angle1_coordinates ||= angle_base_coords(angle1)
    end

    def angle2_coordinates
      @angle2_coordinates ||= angle_base_coords(angle2)
    end

    def angle1_x
      angle1_coordinates[:x_value]
    end

    def angle1_y
      angle1_coordinates[:y_value]
    end

    def angle2_x
      angle2_coordinates[:x_value]
    end

    def angle2_y
      angle2_coordinates[:y_value]
    end

    def slope_of_angles
      # slope = (y2 - y1) / (x2 - x1)
      (angle2_y - angle1_y) / (angle2_x - angle1_x)
    end

    def b_value_for_line
      # SINCE y = mx + b
      # THEN  b = y - mx
      mx_value = (angle1_x * slope_of_angles)

      # If value of mx is Infinity, the line is horizontal, just return angle1_y
      if mx_value == Float::INFINITY
        angle1_y
      else
        angle1_y - mx_value
      end
    end

    def vertical_check(x_input)
      # Since line is vertical, we can just compare x values and map to "above" or "below"
      if angle1_x == x_input
        :on
      elsif angle1_x < x_input
        :above
      else
        :below
      end
    end

    def normal_above_below_check(mx_value, y_input)
      # SINCE y = mx + b
      # We solve for where the y value is for the line between the arc's angles given the slope * input x
      y_value_arc_line = mx_value + b_value_for_line

      if y_value_arc_line == y_input
        # If input y is same as y on the arc line ...input is on the line
        :on
      elsif y_value_arc_line > y_input
        # If input y is more than y on the arc line, point is above the line
        :above
      else
        # If input y is less than y on the arc line, point is below the line
        :below
      end
    end

    def above_below_on(x_input, y_input)
      # SINCE y = mx + b
      # We get mx_value of the line between arc points at the input of x
      mx_value = (x_input * slope_of_angles)

      if mx_value.abs > 1_000_000.00
        # If line is straight up and down, compare with x value to an x coordinate
        vertical_check(x_input)
      else
        # If standard slope...find what the y value between arc points would be given the input x
        normal_above_below_check(mx_value, y_input)
      end
    end

    def angle1_x_smaller_check(x, y)
      # if angle 1 is smaller, point should be above
      above_below_on(x, y) == :above && angle1_x < angle2_x
    end

    def angle2_x_smaller_check(x, y)
      # if angle 2 is smaller, point should be below
      above_below_on(x, y) == :below && angle1_x > angle2_x
    end

    def on_shaded_part?(x, y)
      # This checks if point is on the correct side of the oval, based on the lines between the arc points
      angle1_x_smaller_check(x, y) || angle2_x_smaller_check(x, y)
    end

    def standard_arc_bounds_check?(x, y)
      # Check if it is in the oval, and then if on correct side of the line between points
      inside_oval?(x, y) && on_shaded_part?(x, y)
    end

    def inner_oval_difference
      # this calculates how much smaller the inner oval must be to test a no_fill oval
      @inner_oval_difference ||= calculate_inner_oval_difference
    end

    def calculate_inner_oval_difference
      [style[:strokewidth].to_f, 3.0].max
    end

    def in_bounds?(x, y)
      bounds_check = standard_arc_bounds_check?(x, y)

      if bounds_check && !style[:fill]
        # If no fill, then it is just the edge and needs a further check
        bounds_check = !inside_inner_oval?(x, y)
      end

      bounds_check
    end
  end
end
