module Shoes
  module Swt
    class Line
      include Common::Stroke
      include Common::Resource

      # @param [Hash] opts Options
      #   Must be provided if this shape is responsible for
      #   drawing itself. Omit if this shape is part of another shape.
      def initialize(dsl, opts = nil)
        @dsl = dsl

        @left = opts[:left]
        @top = opts[:top]
        @width = opts[:width]
        @height = opts[:height]

        if opts
          @container = opts[:app].gui.real
          @painter = opts[:paint_callback] || Painter.new(self)
          @container.add_paint_listener(@painter)
        end
      end

      attr_reader :dsl
      attr_reader :container, :element
      attr_reader :paint_callback
      attr_reader :top, :left, :width, :height

      def right
        left + width
      end

      def bottom
        top + height
      end

      class Painter < Common::Painter
        def draw(gc)
          gc.draw_line(@obj.left, @obj.top, @obj.right, @obj.bottom)
        end

        # Don't do fill setup
        def fill_setup(gc)
        end
      end
    end
  end
end
