class Shoes
  module Common
    module Clickable
      def click &blk
        @gui.click &blk
      end
      
      def release &blk
        @gui.release &blk
      end
    end
  end
end
