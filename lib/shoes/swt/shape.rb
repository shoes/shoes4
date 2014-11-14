class Shoes
  module Swt
    class Shape
      include Common::Remove
      include Common::Fill
      include Common::Stroke
      include Common::PainterUpdatesPosition

      # Creates a new Shoes::Swt::Shape
      #
      # @param [Shoes::Shape] dsl The dsl object to provide gui for
      # @param [Hash] opts Initialization options
      #   If this shape is part of another shape (i.e. it is not responsible
      #   for drawing itself), `opts` should be omitted
      def initialize(dsl, app)
        @dsl = dsl
        @app = app
        @element = ::Swt::Path.new(::Swt.display)
        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      def dispose
        @transform.dispose unless @transform.nil? || @transform.disposed?
        @element.dispose   unless @element.nil? || @element.disposed?
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
        native_left
      end

      def top
        native_top
      end

      alias_method :absolute_left, :left
      alias_method :absolute_top, :top
      alias_method :element_left, :left
      alias_method :element_top, :top

      def width
        native_width
      end

      def height
        native_height
      end

      alias_method :element_width, :width
      alias_method :element_height, :height

      def transform
        @transform ||= ::Swt::Transform.new(::Swt.display)
      end

      private

      def new_java_float_array(length)
        Java::float[length].new
      end

      def native_bounds_measurement(element, index)
        bounds_array_size = 4
        bounds = new_java_float_array(bounds_array_size)
        element.get_bounds bounds
        bounds[index]
      end

      def position_from_transform(index)
        transform_elements_size = 6
        elements = new_java_float_array(transform_elements_size)
        transform.get_elements(elements)
        elements[index]
      end

      def native_left
        transform_elements_index_for_left = 4
        position_from_transform transform_elements_index_for_left
      end

      def native_top
        transform_elements_index_for_top = 5
        position_from_transform transform_elements_index_for_top
      end

      def native_height
        bounds_index_for_height = 3
        native_bounds_measurement(@element, bounds_index_for_height)
      end

      def native_width
        bounds_index_for_width = 2
        native_bounds_measurement(@element, bounds_index_for_width)
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
