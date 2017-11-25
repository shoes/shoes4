# frozen_string_literal: true

class Shoes
  module Swt
    class ImagePainter
      include Common::Resource

      def initialize(image)
        @image = image
        @dsl = image.dsl
      end

      def paint_control(event)
        return if @dsl.hidden

        graphics_context = event.gc
        clip_context_to(graphics_context, @dsl.parent) do
          graphics_context.drawImage(@image.real, 0, 0,
                                     @image.full_width, @image.full_height,
                                     @dsl.element_left, @dsl.element_top,
                                     @dsl.element_width, @dsl.element_height)
        end
      end
    end
  end
end
