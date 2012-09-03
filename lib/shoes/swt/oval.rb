module Shoes
  module Swt
    class Oval
      include Common::Fill
      include Common::Stroke
      include Common::Move

      # opts must be provided if this shape is responsible for
      # drawing itself. If this shape is part of another shape, then
      # opts should be empty
      #
      # @param [Shoes::Oval] dsl The dsl object to provide gui for
      # @param [Shoes::Swt::App app The app
      # @param [Hash] opts Options
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
