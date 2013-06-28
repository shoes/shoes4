class Shoes
  module Swt
    class ImagePattern
      def initialize *args
        @path = args.first.path
      end
      
      def apply_as_fill(gc, left, top, width, height, angle = 0)
        pattern = ::Swt::Pattern.new(Shoes.display, ::Swt::Image.new(Shoes.display, @path))
        gc.set_background_pattern pattern
      end
      
      def apply_as_stroke(gc, left, top, width, height, angle = 0)
        pattern = ::Swt::Pattern.new(Shoes.display, ::Swt::Image.new(Shoes.display, @path))
        gc.set_foreground_pattern pattern
      end
    end
  end
end
