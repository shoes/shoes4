class Shoes
  module Swt
    class Shape
      include Common::Fill
      include Common::Stroke
      include Common::PainterUpdatesPosition


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

      def curve_to(cx1, cy1, cx2, cy2, x, y)
        @element.cubic_to(cx1, cy1, cx2, cy2, x, y)
      end

      def arc(x, y, width, height, start_angle, arc_angle)
        @element.add_arc(x - (width / 2), y - (height / 2), width, height,
                         -start_angle * 180 / ::Shoes::PI,
                         (start_angle - arc_angle) * 180 / ::Shoes::PI)
      end

      def update_position
        transform.translate(dsl.element_left, dsl.element_top)
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

      alias_method :absolute_left, :left
      alias_method :absolute_top, :top
      alias_method :element_left, :left
      alias_method :element_top, :top

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

      alias_method :element_width, :width
      alias_method :element_height, :height

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
