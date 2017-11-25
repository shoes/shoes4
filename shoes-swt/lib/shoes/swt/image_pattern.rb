# frozen_string_literal: true

class Shoes
  module Swt
    class ImagePattern
      include Common::Remove
      include Common::ImageHandling

      def initialize(dsl)
        @dsl = dsl
      end

      def dispose
        @image&.dispose
        @pattern&.dispose
      end

      # Since colors are bound up (at least in specs) with image patterns,
      # we can't safely touch images during initialize, so lazily load them.
      def pattern
        @image   ||= ::Swt::Image.new(Shoes.display, load_file_image_data(@dsl.path))
        @pattern ||= ::Swt::Pattern.new(Shoes.display, @image)
        cleanup_temporary_files

        @pattern
      end

      def apply_as_fill(gc, _dsl)
        gc.set_background_pattern pattern
      end

      def apply_as_stroke(gc, _dsl)
        gc.set_foreground_pattern pattern
      end
    end
  end
end
