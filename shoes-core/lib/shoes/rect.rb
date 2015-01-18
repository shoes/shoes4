class Shoes
  class Rect
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    style_with :angle, :art_styles, :curve, :common_styles, :dimensions
    STYLES = { angle: 0 }

    def create_dimensions(left, top, width, height)
      @dimensions = AbsoluteDimensions.new left, top, width, height, @style
    end
  end
end
