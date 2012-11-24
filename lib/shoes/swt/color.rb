module Shoes
  module Swt
    class Color
      def self.create(color)
        color ? new(color) : NullColor.new
      end

      # @param [Shoes::Color] color the DSL representation of this color
      def initialize(color)
        @dsl = color
        @real = ::Swt::Graphics::Color.new(Shoes.display, @dsl.red, @dsl.green, @dsl.blue)
      end

      attr_reader :dsl, :real

      # @return [Integer] the alpha value, from 0 (transparent) to 255 (opaque)
      def alpha
        @dsl.alpha
      end

      # @param [Swt::Graphics::GC] gc the graphics context on which to apply fill
      def apply_as_fill(gc)
        gc.set_background real
        gc.set_foreground real
        gc.set_alpha alpha
      end

      # @param [Swt::Graphics::GC] gc the graphics context on which to apply stroke
      def apply_as_stroke(gc)
        gc.set_foreground real
        gc.set_alpha alpha
      end
    end

    class NullColor
      attr_reader :alpha, :dsl, :real
      def apply_as_fill(gc); end
      def apply_as_stroke(gc); end
    end
  end
end

