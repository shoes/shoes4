# frozen_string_literal: true

class Shoes
  class Arrow < Common::ArtElement
    style_with :art_styles, :curve, :common_styles, :dimensions
    STYLES = { fill: Shoes::COLORS[:black] }.freeze

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

    # Redrawing needs a bit of extra room. We offset by this factor, then
    # extend our size by twice that to evenly surround the whole thing.
    REDRAW_OFFSET_FACTOR = 2
    REDRAW_SIZING_FACTOR = REDRAW_OFFSET_FACTOR * 2

    # Our locations are nonstandard, so let redrawing and gradient know
    def redraw_left
      return 0 unless element_left
      element_left - width * 0.5 - strokewidth.ceil * REDRAW_OFFSET_FACTOR
    end

    def redraw_top
      return 0 unless element_top
      element_top - width * 0.4 - strokewidth.ceil * REDRAW_OFFSET_FACTOR
    end

    def redraw_width
      width + strokewidth.ceil * REDRAW_SIZING_FACTOR
    end

    def redraw_height
      width + strokewidth.ceil * REDRAW_SIZING_FACTOR
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
