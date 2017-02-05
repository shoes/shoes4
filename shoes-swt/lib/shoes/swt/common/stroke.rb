# frozen_string_literal: true
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
          return @cached_swt_stroke if @cached_swt_stroke

          @color_factory ||= ::Shoes::Swt::ColorFactory.new
          @cached_swt_stroke = @color_factory.create(dsl.stroke)
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

        # Just clear it out and let next paint recreate and save our SWT color
        def update_stroke
          @cached_swt_stroke = nil
        end

        def apply_stroke(context)
          if stroke
            stroke.apply_as_stroke(context, self)
            context.set_line_width strokewidth
            true
          end
        end
      end
    end
  end
end
