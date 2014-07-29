class Shoes
  module Common
    module Clickable
      def click(&blk)
        @gui.click blk
      end

      def release(&blk)
        @gui.release blk
      end

      def register_click(styles, blk = nil)
        click(&styles[:click]) if styles[:click]
        click &blk if blk
      end
      
      def set_click(new_styles)
        self.click &new_styles[:click]
      end

    end
  end
end
