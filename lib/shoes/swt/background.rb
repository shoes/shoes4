require 'shoes/color'

module Shoes
  module Swt
    class Background
      include Common::Child

      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk

        @real = parent.real

        if dsl.opts.size == 0
          background = dsl.color.to_native
        else
          @real.addPaintListener(BgPainter.new(@dsl, self))
        end
      end

      def background=(color)
        @real.background = color.to_native
      end

      private

      class BgPainter
        def initialize(dsl, parent)
          @dsl = dsl
          @parent = parent
        end

        def paintControl(paint_event)
          @parent.background = @dsl.default
          coords = @dsl.coords paint_event
          paint_event.gc.setBackground (@dsl.color.to_native)
          paint_event.gc.fillRectangle(coords[:x], coords[:y],
            coords[:width], coords[:height])
        end
      end
    end
  end
end
