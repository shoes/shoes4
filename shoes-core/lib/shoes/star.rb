class Shoes
  class Star
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui
    style_with :angle, :art_styles, :common_styles, :dimensions, :inner, :outer, :points
    STYLES = { angle: 0 }

    def initialize(app, parent, left, top, points, outer, inner, styles = {}, blk = nil)
      @app = app
      @parent = parent

      # Careful not to turn Fixnum to Float, lest Dimensions make you relative!
      width = outer * 2

      # Ignore calculated height on Dimensions--will force to match width
      @dimensions = AbsoluteDimensions.new left, top, width, 0
      @dimensions.height = @dimensions.width

      # Calculate the inner dimensions, which might be relative too
      inner_dimensions = AbsoluteDimensions.new 0, 0, inner * 2, 0

      # Get actual outer/inner from the dimension to handle relative values
      outer = @dimensions.width / 2
      inner = inner_dimensions.width / 2

      # Now set style using adjust outer and inner
      style_init(styles, inner: inner, outer: outer, points: points)

      @parent.add_child self
      @gui = Shoes.backend_for self

      register_click blk
    end

    def in_bounds?(x, y)
      dx = width / 2.0
      dy = height / 2.0
      left - dx <= x && x <= right - dx && top - dy <= y && y <= bottom - dy
    end
  end
end
