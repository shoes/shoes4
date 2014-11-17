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
          @color_factory ||= ::Shoes::Swt::ColorFactory.new
          @color_factory.create(dsl.fill)
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
            left, top = self.is_a?(Star) ? [element_left - element_width / 2.0, element_top - element_height / 2.0] : [element_left, element_top]
            fill.apply_as_fill(context, left, top, element_width, element_height, angle)
            true
          end
        end
      end
    end
  end
end
