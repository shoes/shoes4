class Shoes
  module Common
    module Clickable
      def click(&blk)
        @gui.click &blk
      end

      def release(&blk)
        @gui.release &blk
      end

      def clickable_options(opts)
        click(&opts[:click]) if opts[:click]
      end
    end
  end
end
