class Shoes
  module Swt
    class Line
      include Common::Clickable
      include Common::Stroke
      include Common::Visibility
      include Common::Remove
      include Common::PainterUpdatesPosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :app
      attr_reader :translated_point_a, :translated_point_b
      attr_reader :transform

      # @param [Shoes::Line] dsl The {Shoes::Line} implemented by this object
      # @param [Shoes::Swt::App] app The {Swt::App} this object belongs to
      # @param [Shoes::Point] point_a One endpoint of the line
      # @param [Shoes::Point] point_b The other endpoint of the line
      def initialize(dsl, app)
        @dsl, @app = dsl, app
        translate_according_to_enclosing_box
        @painter = Painter.new(self)
        @app.add_paint_listener(@painter)
      end

      def dispose
        @transform.dispose unless @transform.disposed?
      end

      def angle
        @dsl.angle
      end

      def update_position
        translate_according_to_enclosing_box
      end

      private

      def translate_according_to_enclosing_box
        @translated_point_a = @dsl.point_a.to(-left, -top)
        @translated_point_b = @dsl.point_b.to(-left, -top)
        @transform          = ::Swt::Transform.new(::Swt.display)
        @transform_elements = Java::float[6].new
        @transform.get_elements @transform_elements
        @transform.set_elements @transform_elements[0], @transform_elements[1], @transform_elements[2], @transform_elements[3], dsl.element_left, dsl.element_top
      end

      class Painter < Common::Painter
        def draw(gc)
          point_a, point_b = @obj.translated_point_a, @obj.translated_point_b
          gc.draw_line(point_a.x, point_a.y, point_b.x, point_b.y)
        end

        # Don't do fill setup
        def fill_setup(_gc)
        end
      end
    end
  end
end
