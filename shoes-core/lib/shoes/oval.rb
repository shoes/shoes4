class Shoes
  class Oval
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    style_with :art_styles, :center, :common_styles, :dimensions, :radius

    def create_dimensions(left, top, width, height)
      left   ||= @style[:left]
      top    ||= @style[:top]
      width  ||= @style[:diameter] || @style[:width] || (@style[:radius] || 0) * 2
      height ||= @style[:height] || width

      @dimensions = AbsoluteDimensions.new left, top, width, height, @style
    end
  end
end
