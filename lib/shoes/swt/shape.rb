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

      def move(left, top)
        @transform = ::Swt::Transform.new(::Swt.display)
        @transform.translate(left, top)
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
