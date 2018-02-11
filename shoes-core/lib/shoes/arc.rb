# frozen_string_literal: true

class Shoes
  class Arc < Common::ArtElement
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

    def radius_x
      @radius_x ||= width.to_f / 2
    end

    def radius_y
      @radius_y ||= height.to_f / 2
    end

    def middle_y
      @middle_y ||= left + radius_x
    end

    def middle_x
      @middle_x ||= top + radius_y
    end

    def oval_in_bounds?(x, y)
      x_side = (((x - middle_x)**2).to_f / radius_x**2)
      y_side = (((y - middle_y)**2).to_f / radius_y**2)

      x_side + y_side <= 1
    end

    def angle_from_coordinates_base_equation(axis, input_angle)
      top_of_angle_coordinate_equation = (radius_x * radius_y)

      if axis == :y
        top_of_angle_coordinate_equation / ( ( (radius_x ** 2) + ((radius_y ** 2) * (Math::tan(modded_angle) ** 2) ) ) ** 0.5 )
      else
        top_of_angle_coordinate_equation / ( ( (radius_y ** 2) + ((radius_x ** 2) / (Math::tan(modded_angle) ** 2) ) ) ** 0.5 )
      end
    end

    def angle_base_coords(given_angle)
      # https://math.stackexchange.com/questions/22064/calculating-a-point-that-lies-on-an-ellipse-given-an-angle
      # The above link was used in creating this method...but the implementation varies due to nature of shoes

      # Must pad angle, since angles in here start at different location on the ellipse
      modded_angle = given_angle + 1.5708

      x_check = angle_from_coordinates_base_equation(:x, modded_angle)
      y_check = angle_from_coordinates_base_equation(:y, modded_angle)

      if ((0 <= modded_angle) && (modded_angle <= 1.5708)) || ((4.71239 <= modded_angle) && (modded_angle <= 6.28319))
        y_check = middle_x - y_check
      else
        y_check = middle_x + y_check
      end

      if (0 <= modded_angle) &&  (modded_angle <= 3.14159)
        x_check = middle_y + x_check
      else
        x_check = middle_y - x_check
      end

      {x_value: x_check.round(3), y_value: y_check.round(3)}
    end

    def angle1_coordinates
      @angle1_coordinates ||=  angle_base_coords(angle1)
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

      if mx_value == Float::INFINITY
        angle1_y
      else
        angle1_y - mx_value
      end
    end

    def vertical_check(x_input)
      # The above/below are
      if angle1_x == x_input
        :on
      elsif angle1_x < x_input
        :above
      else
        :below
      end
    end

    def normal_above_below_check(mx_value, y_input)
      right_side_of_equation = mx_value + b_value_for_line

      if right_side_of_equation == y_input
        # If input y is same...input is on the line
        :on
      elsif right_side_of_equation > y_input
        # If input y is more, point is above the line
        :above
      else
        # If input y is less, point is below the line
        :below
      end
    end


    def above_below_on(x_input, y_input)
      mx_value = (x_input * slope_of_angles)

      if mx_value.abs > 1_000_000.00
        # If line is straight up and down..compare with x value to an x coordinate
        vertical_check(x_input)
      else
        # If standard slope...find what the y value would be given the input x.
        normal_above_below_check(mx_value, y_input)
      end
    end

    def in_bounds?(x, y)
      if oval_in_bounds?(x, y)
        if above_below_on(x,y) == :below && angle1 < angle2
          true
        elsif above_below_on(x,y) == :above && angle1 > angle2
          true
        end
      end
    end
  end
end
