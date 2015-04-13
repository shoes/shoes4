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
          return @swt_fill if @swt_fill

          @color_factory ||= ::Shoes::Swt::ColorFactory.new
          @swt_fill = @color_factory.create(dsl.fill)
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

        # Just clear it out and let next paint recreate and save our SWT color
        def update_fill
          @swt_fill = nil
        end

        def apply_fill(context)
          if fill
            fill.apply_as_fill(context, self)
            true
          end
        end
      end
    end
  end
end
