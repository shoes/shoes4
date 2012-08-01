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
        @real.addPaintListener(BgPainter.new(@dsl, @parent.dsl))
      end

      private

      class BgPainter
        include Common::Resource

        def initialize(dsl, parent)
          @dsl = dsl
          @parent = parent
        end

        def paintControl(paint_event)
          gc = paint_event.gc
          gcs_reset gc
          @dsl.width = @dsl.opts[:width] ? @dsl.opts[:width] : @parent.width
          @dsl.height = @dsl.opts[:height] ? @dsl.opts[:height] : @parent.height
          gc.setBackground (@dsl.color.to_native)
          gc.fillRoundRectangle(@parent.left, @parent.top, 
            @dsl.width, @dsl.height, @dsl.curve*2, @dsl.curve*2)
        end
      end
    end
  end
end
