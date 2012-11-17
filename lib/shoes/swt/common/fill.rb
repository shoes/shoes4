module Shoes
  module Swt
    module Common
      # Methods for retrieving fill values from a Shoes DSL class
      #
      # @note Including classes must provide `#dsl`
      module Fill
        DEFAULT_COLOR = 
        # This object's fill color
        #
        # @return [Swt::Graphics::Color] The Swt representation of this object's fill color
        def fill
          dsl.fill.to_native if dsl.fill
        end

        # This object's fill alpha value
        #
        # @return [Integer] The alpha value of this object's fill color (0-255)
        def fill_alpha
          dsl.fill.alpha if dsl.fill
        end

        # @param [Swt::Graphics::GC] gc the graphics context in which to apply fill
        def apply_fill(gc)
          fill.apply_as_background(gc)
          #gc.background = self.fill
          #gc.alpha = self.fill_alpha
        end
      end
    end
  end
end
