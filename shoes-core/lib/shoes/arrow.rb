# frozen_string_literal: true
class Shoes
  class Arrow < Common::ArtElement
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

    # Our locations are nonstandard, so let redrawing and gradient know
    def redraw_left
      return 0 unless element_left
      element_left - width * 0.5
    end

    def redraw_top
      return 0 unless element_top
      element_top - width * 0.4
    end

    def redraw_height
      width * 0.8
    end

    def gradient_left
      redraw_left
    end

    def gradient_top
      redraw_top
    end

    def gradient_height
      redraw_height
    end
  end
end
