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
  # @author Jason Clark
  # @param left [Integer] The number of pixels from the left side of the window.
  # @param top [Integer] The number of pixels from the top side of the window
  # @param width [Integer] The width of the arc element.
  # @param height [Integer] The height of the arc element.
  # @param angle1 [Float] The first angle of the arc to the center point, in Radians,
  #   starting from the 3 o'clock position.
  # @param angle2 [Float] The second angle of the arc to the center point, in Radians.
  # @param [Hash] Style hash
  class Arc < Common::ArtElement
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
  end
end
