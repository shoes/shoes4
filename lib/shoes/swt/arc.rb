class Shoes
  module Swt
    class Arc
      include Common::Clickable
      include Common::Fill
      include Common::Stroke
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::Remove
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :app, :transform

      # Creates a new Shoes::Swt::Arc
      #
      # @param [Shoes::Arc] dsl The DSL object represented by this implementation
      # @param [Shoes::Swt::App] app The implementation object of the Shoes app
      def initialize(dsl, app)
        @dsl = dsl
        @app = app
        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      def angle1
        radians_to_degrees dsl.angle1
      end

      def angle2
        radians_to_degrees dsl.angle2
      end

      def wedge?
        dsl.wedge?
      end

      private

      def radians_to_degrees(radians)
        radians * 180 / ::Shoes::PI
      end

      public

      class Painter < Common::Painter
        def fill(graphics_context)
          if @obj.wedge?
            graphics_context.fill_arc(@obj.element_left, @obj.element_top,
                                      @obj.element_width, @obj.element_height,
                                      @obj.angle1, @obj.angle2 * -1)
          else
            path = ::Swt::Path.new(::Swt.display)
            path.add_arc(@obj.element_left, @obj.element_top,
                         @obj.element_width, @obj.element_height,
                         @obj.angle1, @obj.angle2 * -1)
            graphics_context.fill_path(path)
          end
        end

        def draw(graphics_context)
          sw = graphics_context.get_line_width
          if @obj.element_left && @obj.element_top && @obj.element_width && @obj.element_height
            graphics_context.draw_arc(@obj.element_left + sw / 2,
                                      @obj.element_top + sw / 2,
                                      @obj.element_width - sw,
                                      @obj.element_height - sw,
                                      @obj.angle1, @obj.angle2 * -1)
          end
        end
      end
    end
  end
end
