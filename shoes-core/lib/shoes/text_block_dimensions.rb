# frozen_string_literal: true
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

    # This is the width the text block initially wants to try to fit in.
    #
    # If an explicit containing width is provided, trust that most
    # If we've gotten an explicit width, use that but check that we fit still
    # Last but certainly not least, consult what's remaining in our parent.
    def desired_width(containing = nil)
      desired = if containing
                  parent.absolute_left + containing - absolute_left
                elsif element_width
                  [element_width, remaining_in_parent].min
                else
                  remaining_in_parent
                end

      desired - margin_left - margin_right
    end

    # If an explicit width's set, use that when asking how much space we need.
    # If not, we look to the parent.
    def containing_width
      element_width || parent.element_width
    end

    def remaining_in_parent
      parent.absolute_left + parent.element_width - absolute_left
    end
  end

  module TextBlockDimensionsDelegations
    extend Forwardable

    DELEGATED_METHODS = TextBlockDimensions.public_instance_methods(false)

    def_delegators :dimensions, *DELEGATED_METHODS
  end
end
