class Shoes
  # We take over a bunch of the absolute_* measurements since the jagged
  # shape of a flowed TextBlock doesn't follow the usual rules for dimensions
  # when we get to positioning (which is the main use of these values).
  class TextBlockDimensions < Dimensions

    attr_writer :absolute_right, :absolute_bottom,
                :calculated_width, :calculated_height

    def absolute_right
      @absolute_right || super
    end

    def absolute_bottom
      @absolute_bottom || super
    end

    # It might seem weird these reverse from above, but if explicit sizes get
    # reported verbatim, while boundaries are set by text fitting.
    def width
      super || @calculated_width
    end

    def height
      super || @calculated_height
    end
  end
end
