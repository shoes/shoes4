class Shoes
  class Star
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    style_with :angle, :art_styles, :common_styles, :dimensions, :inner, :outer, :points
    STYLES = { angle: 0 }

    def create_dimensions(left, top, points, outer, inner)
      # Don't use param defaults as DSL explicit passes nil for missing params
      points ||= 10
      outer  ||= 100.0
      inner  ||= 50.0

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
  end
end
