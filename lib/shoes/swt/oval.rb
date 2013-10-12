class Shoes
  module Swt
    class Oval
      include Common::Fill
      include Common::Stroke
      include Common::Clickable
      include Common::Toggle
      include Common::Clear
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :transform, :painter, :container


      # @param [Shoes::Oval] dsl the dsl object to provide gui for
      # @param [Shoes::Swt::App] app the app
      # @param [Hash] opts options
      def initialize(dsl, app, &blk)
        @dsl = dsl
        @app = app
        @container = @app.real

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
        clickable blk if blk
      end

      class Painter < Common::Painter
        def clipping
          clipping = ::Swt::Path.new(Shoes.display)
          clipping.add_arc(@obj.left, @obj.top, @obj.width, @obj.height, 0, 360)
          clipping
        end

        def fill(gc)
          gc.fill_oval(@obj.left, @obj.top, @obj.width, @obj.height)
        end

        def draw(gc)
          sw = gc.get_line_width
          gc.draw_oval(@obj.left+sw/2, @obj.top+sw/2, @obj.width-sw, @obj.height-sw)
        end
      end
    end
  end
end
