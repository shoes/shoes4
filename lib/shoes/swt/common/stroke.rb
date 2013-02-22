module Shoes
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
          dsl.stroke ? ::Shoes.configuration.backend_for(dsl.stroke) : nil
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
            l, t = self.is_a?(Star) ? [left-width/2.0, top-height/2.0] : [left, top]
            stroke.apply_as_stroke(context, l, t, width, height, angle)
            context.set_line_width strokewidth
            true
          end
        end
      end
    end
  end
end
