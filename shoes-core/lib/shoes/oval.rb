# frozen_string_literal: true

class Shoes
  class Oval < Common::ArtElement
    style_with :art_styles, :center, :common_styles, :dimensions
    STYLES = { fill: Shoes::COLORS[:black] }.freeze

    def create_dimensions(left, top, width, height)
      left   ||= @style[:left] || 0
      top    ||= @style[:top] || 0
      width  ||= @style[:width] || @style[:diameter] || (@style[:radius] || 0) * 2
      height ||= @style[:height] || width

      @dimensions = AbsoluteDimensions.new left, top, width, height, @style
    end

    # Check out http://math.stackexchange.com/questions/60070/checking-whether-a-point-lies-on-a-wide-line-segment
    # for explanations how the algorithm works
    def in_bounds?(x, y)
      radius_x = width.to_f / 2
      radius_y = height.to_f / 2

      middle_x = left + radius_x
      middle_y = top + radius_y

      x_side = (((x - middle_x)**2).to_f / radius_x**2)
      y_side = (((y - middle_y)**2).to_f / radius_y**2)

      x_side + y_side <= 1
    end
  end
end
