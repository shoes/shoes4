class Shoes
  module Swt
    class ImagePattern
      include Common::Remove

      def initialize(dsl)
        @dsl = dsl
      end

      def dispose
        @image.dispose if @image
      end

      def apply_as_fill(gc, dsl)
        draw_image_pattern(gc, dsl)
        false
      end

      def apply_as_stroke(gc, dsl)
        draw_image_pattern(gc, dsl)
        false
      end

      def draw_image_pattern(gc, dsl)
        # Since colors are bound up (at least in specs) with image patterns,
        # we can't safely touch images during initialize, so lazily load them.
        @image ||= ::Swt::Image.new(Shoes.display, @dsl.path)

        # +1 on count to allow partial image at end of the line
        bounds  = @image.bounds
        cols = dsl.width / bounds.width + 1
        rows = dsl.height / bounds.height + 1

        cols.times do |col|
          rows.times do |row|
            desired_width = bounds.width
            desired_height = bounds.height

            left   = dsl.element_left + (col * bounds.width)
            right  = left + desired_width
            top    = dsl.element_top + (row * bounds.height)
            bottom = top + desired_height

            if left < dsl.element_right && top < dsl.element_bottom
              desired_width = dsl.element_right - left  if right > dsl.element_right
              desired_height = dsl.element_bottom - top if bottom > dsl.element_bottom

              gc.draw_image @image,
                            0, 0, desired_width, desired_height,
                            left, top, desired_width, desired_height
            end
          end
        end
      end
    end
  end
end
