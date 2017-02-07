# frozen_string_literal: true
class Shoes
  class Oval < Common::ArtElement
    style_with :art_styles, :center, :common_styles, :dimensions, :radius
    STYLES = { fill: Shoes::COLORS[:black] }.freeze

    def create_dimensions(left, top, width, height)
      left   ||= @style[:left] || 0
      top    ||= @style[:top] || 0
      width  ||= @style[:diameter] || @style[:width] || (@style[:radius] || 0) * 2
      height ||= @style[:height] || width

      @dimensions = AbsoluteDimensions.new left, top, width, height, @style
    end
  end
end
