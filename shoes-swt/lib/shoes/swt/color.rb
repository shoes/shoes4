# frozen_string_literal: true

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
        real.dispose
      end

      attr_reader :dsl

      # @return [Integer] the alpha value, from 0 (transparent) to 255 (opaque)
      def alpha
        @dsl.alpha
      end

      # @param [Swt::Graphics::GC] gc the graphics context on which to apply fill
      # @dsl unused by this method, passed to satisfy the Pattern interface
      def apply_as_fill(gc, _dsl = nil)
        gc.set_background real
        gc.set_alpha alpha
      end

      # @param [Swt::Graphics::GC] gc the graphics context on which to apply stroke
      # @dsl unused by this method, passed to satisfy the Pattern interface
      def apply_as_stroke(gc, _dsl = nil)
        gc.set_foreground real
        gc.set_alpha alpha
      end
    end

    class NullColor
      attr_reader :alpha, :dsl, :real
      def apply_as_fill(_gc, _dsl); end

      def apply_as_stroke(_gc, _dsl); end
    end
  end
end
