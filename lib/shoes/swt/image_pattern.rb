class Shoes
  module Swt
    class ImagePattern
      include Common::Remove

      def initialize(dsl)
        @dsl = dsl
      end

      def dispose
        @image.dispose if @image
        @pattern.dispose if @pattern
      end

      # Since colors are bound up (at least in specs) with image patterns,
      # we can't safely touch images during initialize, so lazily load them.
      def pattern
        @image   ||= ::Swt::Image.new(Shoes.display, @dsl.path)
        @pattern ||= ::Swt::Pattern.new(Shoes.display, @image)
      end

      def apply_as_fill(gc, _left, _top, _width, _height, _angle = 0)
        gc.set_background_pattern pattern
      end

      def apply_as_stroke(gc, _left, _top, _width, _height, _angle = 0)
        gc.set_foreground_pattern pattern
      end
    end
  end
end
