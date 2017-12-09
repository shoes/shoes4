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

    def center_point
      center_x = left + (element_width * 0.5).to_i
      center_y = top + (element_height * 0.5).to_i
      Point.new(center_x, center_y)
    end

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
