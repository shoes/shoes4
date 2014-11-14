class Shoes
  module Swt
    class Color
      include DisposedProtection

      def self.create(color)
        color ? new(color) : NullColor.new
      end

      # @param [Shoes::Color] color the DSL representation of this color
      def initialize(color)
        @dsl = color
        @real = ::Swt::Graphics::Color.new(Shoes.display, @dsl.red, @dsl.green, @dsl.blue)
      end

      def dispose
        @real.dispose unless @real.disposed?
      end

      attr_reader :dsl

      # @return [Integer] the alpha value, from 0 (transparent) to 255 (opaque)
      def alpha
        @dsl.alpha
      end

      # @param [Swt::Graphics::GC] gc the graphics context on which to apply fill
      # @note left, top, width, height, and angle are not used in this method, and only
      #   exist to satisfy the Pattern interface
      def apply_as_fill(gc, _left = nil, _top = nil, _width = nil, _height = nil, _angle = nil)
        gc.set_background real
        gc.set_alpha alpha
      end

      # @param [Swt::Graphics::GC] gc the graphics context on which to apply stroke
      def apply_as_stroke(gc, _left = nil, _top = nil, _width = nil, _height = nil, _angle = nil)
        gc.set_foreground real
        gc.set_alpha alpha
      end
    end

    class NullColor
      attr_reader :alpha, :dsl, :real
      def apply_as_fill(_gc); end

      def apply_as_stroke(_gc); end
    end
  end
end
