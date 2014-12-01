class Shoes
  module Swt
    module Common
      # Methods for retrieving stroke values from a Shoes DSL class
      #
      # @note Including classes must provide `#dsl`
      module Stroke
        # This object's stroke color
        #
        # @return [Swt::Graphics::Color] The Swt representation of this object's stroke color
        def stroke
          @color_factory ||= ::Shoes::Swt::ColorFactory.new
          @color_factory.create(dsl.stroke)
        end

        # This object's stroke alpha value
        #
        # @return [Integer] The alpha value of this object's stroke color (0-255)
        def stroke_alpha
          dsl.stroke.alpha if dsl.stroke
        end

        # This object's strokewidth
        #
        # @return [Integer] This object's strokewidth
        def strokewidth
          dsl.strokewidth
        end

        def apply_stroke(context)
          if stroke
            l, t = self.is_a?(Star) ? [element_left - element_width / 2.0, element_top - element_height / 2.0] : [element_left, element_top]
            stroke.apply_as_stroke(context, l, t, element_width, element_height, angle)
            context.set_line_width strokewidth
            true
          end
        end
      end
    end
  end
end
