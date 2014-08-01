class Shoes
  class Star
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui
    style_with :angle, :art_styles, :dimensions, :inner, :outer, :points

    def initialize(app, parent, left, top, points, outer, inner, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init(styles, inner: inner, outer: outer, points: points)

      # Careful not to turn Fixnum to Float, lest Dimensions make you relative!
      width = outer*2

      # Ignore calculated height on Dimensions--will force to match width
      @dimensions = AbsoluteDimensions.new left, top, width, 0
      @dimensions.height = @dimensions.width

      # Calculate the inner dimensions, which might be relative too
      inner_dimensions = AbsoluteDimensions.new 0, 0, inner*2, 0

      # Get actual outer/inner from the dimension to handle relative values
      @style[:outer] = @dimensions.width / 2
      @style[:inner] = inner_dimensions.width / 2

      @parent.add_child self
      @gui = Shoes.backend_for(self)

      register_click(@style, blk)
    end

    def in_bounds?(x, y)
      dx = width / 2.0
      dy = height / 2.0
      left - dx <= x and x <= right - dx and top - dy <= y and y <= bottom - dy
    end

  end
end
