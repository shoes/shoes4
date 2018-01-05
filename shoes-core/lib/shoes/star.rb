# frozen_string_literal: true

class Shoes
  class Star < Common::ArtElement
    style_with :art_styles, :center, :common_styles, :dimensions, :inner, :outer, :points
    STYLES = { fill: Shoes::COLORS[:black] }.freeze

    # Don't use param defaults as DSL explicit passes nil for missing params
    def create_dimensions(left, top, points, outer, inner)
      left ||= @style[:left] || 0
      top  ||= @style[:top] || 0

      points ||= @style[:points] || 10
      outer  ||= @style[:outer] || 100.0
      inner  ||= @style[:inner] || 50.0

      # Careful not to turn Fixnum to Float, lest Dimensions make you relative!
      width = outer * 2

      # Ignore calculated height on Dimensions--will force to match width
      @dimensions = AbsoluteDimensions.new left, top, width, 0
      @dimensions.height = @dimensions.width

      # Calculate the inner dimensions, which might be relative too
      inner_dimensions = AbsoluteDimensions.new 0, 0, inner * 2, 0

      # Get actual outer/inner from the dimension to handle relative values
      style[:outer]  = @dimensions.width / 2
      style[:inner]  = inner_dimensions.width / 2
      style[:points] = points
    end

    def in_bounds?(x, y)
      dx = width / 2.0
      dy = height / 2.0
      element_left - dx <= x && x <= element_right - dx &&
        element_top - dy <= y && y <= element_bottom - dy
    end

    def redraw_left
      return 0 unless element_left
      calculated_left = super
      calculated_left = element_left - width * 0.5 if center
      calculated_left - style[:strokewidth].to_i * 2
    end

    def redraw_top
      return 0 unless element_top
      calculated_top = super
      calculated_top = element_top - width * 0.5 if center
      calculated_top - style[:strokewidth].to_i * 2
    end

    def redraw_width
      element_width + style[:strokewidth].to_i * 4
    end

    def redraw_height
      element_height + style[:strokewidth].to_i * 4
    end

    def center_point
      center_x = left + (element_width * 0.5).to_i
      center_y = top + (element_height * 0.5).to_i
      Point.new(center_x, center_y)
    end

    def center_point=(point)
      self.left = point.x - (width * 0.5).to_i
      self.top = point.y - (height * 0.5).to_i
    end
  end
end
