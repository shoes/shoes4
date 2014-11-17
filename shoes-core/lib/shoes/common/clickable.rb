class Shoes
  module Common
    module Clickable
      attr_accessor :pass_coordinates

      def click(&blk)
        @gui.click blk
      end

      def release(&blk)
        @gui.release blk
      end

      def register_click(blk = nil)
        click(&@style[:click]) if @style[:click]
        click(&blk) if blk
      end

      def pass_coordinates?
        @pass_coordinates
      end
    end
  end
end
