# frozen_string_literal: true
class Shoes
  class Rect < Common::ArtElement
    style_with :art_styles, :curve, :common_styles, :dimensions
    STYLES = { curve: 0, fill: Shoes::COLORS[:black] }.freeze

    def create_dimensions(left, top, width, height)
      left   ||= @style[:left] || 0
      top    ||= @style[:top] || 0
      width  ||= @style[:width] || 0
      height ||= @style[:height] || width

      @dimensions = AbsoluteDimensions.new left, top, width, height, @style
    end
  end
end
