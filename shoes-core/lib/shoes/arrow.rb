class Shoes
  class Arrow
    include Common::ArtElement
    include Common::Style

    style_with :angle, :art_styles, :curve, :common_styles, :dimensions
    STYLES = { angle: 0, fill: Shoes::COLORS[:black] }.freeze

    def create_dimensions(left, top, width)
      left   ||= @style[:left] || 0
      top    ||= @style[:top] || 0
      width  ||= @style[:width] || 0

      @dimensions = AbsoluteDimensions.new left, top, width, width, @style
    end

    def width=(*_)
      super
      gui.update_position
    end
  end
end
