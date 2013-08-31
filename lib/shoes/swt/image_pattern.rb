class Shoes
  module Swt
    class ImagePattern
      def initialize(dsl)
        @dsl = dsl
      end
      
      def apply_as_fill(gc, left, top, width, height, angle = 0)
        pattern = ::Swt::Pattern.new(Shoes.display, ::Swt::Image.new(Shoes.display, @dsl.path))
        gc.set_background_pattern pattern
      end
      
      def apply_as_stroke(gc, left, top, width, height, angle = 0)
        pattern = ::Swt::Pattern.new(Shoes.display, ::Swt::Image.new(Shoes.display, @dsl.path))
        gc.set_foreground_pattern pattern
      end
    end
  end
end
