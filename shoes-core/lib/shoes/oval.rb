class Shoes
  class Oval
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    style_with :art_styles, :center, :common_styles, :dimensions, :radius

    def create_dimensions(left, top, width, height)
      @dimensions = AbsoluteDimensions.new left, top, width, height, @style
    end
  end
end
