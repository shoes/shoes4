module Shoes
  module Swt
    class Border
      include Common::Fill
      include Common::Stroke
      include Common::Clear

      def initialize(dsl, app, left, top, width, height, opts = {}, &blk)
        @dsl = dsl
        @app = app
        @container = @app.real
        @left = left
        @top = top
        @width = width
        @height = height
        @opts = opts
        @corners = opts[:curve] || 0

        dsl.parent.contents << @dsl

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      attr_reader :dsl
      attr_reader :transform
      attr_reader :painter
      attr_reader :opts
      attr_reader :corners
      attr_accessor :left, :top, :width, :height

      class Painter < Common::Painter

        def fill(gc)
          # do nothing
        end

        def draw(gc)
          set_position_and_size
          sw = gc.get_line_width
          gc.draw_round_rectangle(@obj.left+sw/2, @obj.top+sw/2, @obj.width-sw, @obj.height-sw, @obj.corners*2, @obj.corners*2)
        end
      end
    end
  end
end
