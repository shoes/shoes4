# frozen_string_literal: true
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
            left   = dsl.element_left + (col * bounds.width)
            right  = left + bounds.width

            top    = dsl.element_top + (row * bounds.height)
            bottom = top + bounds.height

            if fits_in_dsl?(left, top, dsl)
              draw_image(gc, left, top,
                         desired_width(left, right, bounds, dsl),
                         desired_height(top, bottom, bounds, dsl))
            end
          end
        end
      end

      def fits_in_dsl?(left, top, dsl)
        left < dsl.element_right && top < dsl.element_bottom
      end

      def desired_width(left, right, bounds, dsl)
        if right > dsl.element_right
          dsl.element_right - left
        else
          bounds.width
        end
      end

      def desired_height(top, bottom, bounds, dsl)
        if bottom > dsl.element_bottom
          dsl.element_bottom - top
        else
          bounds.height
        end
      end

      def draw_image(gc, left, top, desired_width, desired_height)
        gc.draw_image @image,
                      0, 0, desired_width, desired_height,
                      left, top, desired_width, desired_height
      end
    end
  end
end
