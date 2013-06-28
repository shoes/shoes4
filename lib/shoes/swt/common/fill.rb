class Shoes
  module Swt
    module Common
      # Methods for retrieving fill values from a Shoes DSL class
      #
      # @note Including classes must provide `#dsl`
      module Fill
        # This object's fill color
        #
        # @return [Swt::Graphics::Color] The Swt representation of this object's fill color
        def fill
          dsl.fill ? ::Shoes.configuration.backend_for(dsl.fill) : nil
        end

        # This object's fill alpha value
        #
        # @return [Integer] The alpha value of this object's fill color (0-255)
        def fill_alpha
          fill.alpha
        end

        # @return [Integer] the angle to use when filling with a pattern
        def angle
          @angle || 0
        end

        def apply_fill(context)
          if fill
            l, t = self.is_a?(Star) ? [left-width/2.0, top-height/2.0] : [left, top]
            fill.apply_as_fill(context, l, t, width, height, angle)
            true
          end
        end
      end
    end
  end
end
