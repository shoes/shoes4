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
          dsl.stroke.to_native
        end

        # This object's strokewidth
        #
        # @return [Integer] This object's strokewidth
        def strokewidth
          dsl.strokewidth
        end
      end
    end
  end
end
