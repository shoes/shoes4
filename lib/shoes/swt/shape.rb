module Shoes
  module Swt
    # The Swt implementation of a Shoes::Shape
    class Shape
      include Common::Fill
      include Common::Stroke

      # Creates a new Shoes::Swt::Shape
      #
      # @param [Shoes::Shape] dsl The dsl object to provide gui for
      # @param [Hash] opts Initialization options
      #   If this shape is part of another shape (i.e. it is not responsible
      #   for drawing itself), `opts` should be omitted
      def initialize(dsl, app, opts = {})
        @dsl = dsl
        @app = app
        @element = ::Swt::Path.new(::Swt.display)
        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      attr_reader :dsl, :app
      attr_reader :element, :transform
      attr_reader :painter

      def line_to(x, y)
        @element.line_to(x, y)
      end

      def move_to(x, y)
        @element.move_to(x, y)
      end

      def quad_to *args
        @element.quad_to *args
      end

      def curve_to *args
        @element.cubic_to *args
      end

      def move(left, top)
        transform.translate(left, top)
      end

      def left
        elements = Java::float[6].new
        transform.get_elements(elements)
        elements[4]
      end

      def top
        elements = Java::float[6].new
        transform.get_elements(elements)
        elements[5]
      end

      def width
        bounds = Java::float[4].new
        @element.get_bounds(bounds)
        bounds[2]
      end

      def height
        bounds = Java::float[4].new
        @element.get_bounds(bounds)
        bounds[3]
      end

      def transform
        @transform ||= ::Swt::Transform.new(::Swt.display)
      end

      class Painter < Common::Painter

        def fill(gc)
          gc.fill_path(@obj.element)
        end

        def draw(gc)
          gc.draw_path(@obj.element)
        end
      end
    end
  end
end
