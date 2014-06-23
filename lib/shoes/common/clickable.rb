class Shoes
  module Common
    module Clickable
      def click(&blk)
        @gui.click &blk
      end

      def release(&blk)
        @gui.release &blk
      end

      def register_click(styles, blk = nil)
        click(&styles[:click]) if styles[:click]
        @gui.clickable blk if blk
      end
    end
  end
end
