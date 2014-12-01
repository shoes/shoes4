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

    # Since we flow, try to fit in almost any space
    def fitting_width
      10
    end

    # This is the width the text block initially wants to try and fit into.
    def desired_width(containing = containing_width)
      parent.absolute_left + containing - absolute_left
    end

    # If an explicit width's set, use that when asking how much space we need.
    # If not, we look to the parent.
    def containing_width
      element_width || parent.element_width
    end
  end

  module TextBlockDimensionsDelegations
    extend Forwardable

    DELEGATED_METHODS = TextBlockDimensions.public_instance_methods(false)

    def_delegators :dimensions, *DELEGATED_METHODS
  end
end
