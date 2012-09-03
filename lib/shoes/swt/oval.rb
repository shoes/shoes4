module Shoes
  module Swt
    class Oval
      include Common::Fill
      include Common::Stroke
      include Common::Move

      # @param [Shoes::Oval] dsl the dsl object to provide gui for
      # @param [Shoes::Swt::App] app the app
      # @param [Hash] opts options
      def initialize(dsl, app, left, top, width, height, opts = {})
        @dsl = dsl
        @app = app
        @container = @app.real
        @left = left
        @top = top
        @width = width
        @height = height

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      attr_reader :dsl
      attr_reader :transform
      attr_reader :painter
      attr_accessor :width, :height, :left, :top

      class Painter < Common::Painter
        def fill(gc)
          gc.fill_oval(@obj.left, @obj.top, @obj.width, @obj.height)
        end

        def draw(gc)
          gc.draw_oval(@obj.left, @obj.top, @obj.width, @obj.height)
        end
      end
    end
  end
end
