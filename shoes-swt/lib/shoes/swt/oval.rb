class Shoes
  module Swt
    class Oval
      include Common::Fill
      include Common::Stroke
      include Common::Clickable
      include Common::PainterUpdatesPosition
      include Common::Visibility
      include Common::Remove
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :app, :transform, :painter, :container

      # @param [Shoes::Oval] dsl the dsl object to provide gui for
      # @param [Shoes::Swt::App] app the app
      # @param [Hash] opts options
      def initialize(dsl, app)
        @dsl = dsl
        @app = app
        @container = @app.real

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      def update_position
        # No-op, since it has its own painter
      end

      class Painter < Common::Painter
        def clipping
          clipping = ::Swt::Path.new(Shoes.display)
          clipping.add_arc(@obj.element_left, @obj.element_top,
                           @obj.element_width, @obj.element_height, 0, 360)
          clipping
        end

        def fill(graphics_context)
          graphics_context.fill_oval(@obj.element_left, @obj.element_top,
                                     @obj.element_width, @obj.element_height)
        end

        def draw(graphics_context)
          sw = graphics_context.get_line_width
          graphics_context.draw_oval(@obj.element_left + sw / 2, @obj.element_top + sw / 2,
                                     @obj.element_width - sw, @obj.element_height - sw)
        end
      end
    end
  end
end
