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
      # @param [Hash] opts Options
      # @todo This (mostly) duplicates Shoes::Swt::Line#gui_init
      # @todo Figure out what is the `@real` object here
      def initialize(dsl, opts = nil)
        @dsl = dsl

        @left   = opts[:left]
        @top    = opts[:top]
        @width  = opts[:width]
        @height = opts[:height]

        @fill, @stroke = @dsl.fill, @dsl.stroke
        @app = opts[:app]
        if opts
          @painter = Painter.new(self)
          @app.add_paint_listener @painter
        end
      end

      attr_reader :dsl
      attr_reader :container
      attr_reader :paint_callback
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
