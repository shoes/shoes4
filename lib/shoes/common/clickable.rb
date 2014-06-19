class Shoes
  module Common
    module Clickable
      def click(&blk)
        @gui.click &blk
      end

      def release(&blk)
        @gui.release &blk
      end

      def register_click(styles, &blk)
        click(&styles[:click]) if styles[:click]
        @gui.clickable &blk
      end

      # Can throw away this method once all elements are changed
      def clickable_options(opts)
        click(&opts[:click]) if opts[:click]
      end

    end
  end
end
