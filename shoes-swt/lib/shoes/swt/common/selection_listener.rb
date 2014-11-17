class Shoes
  module Swt
    class SelectionListener
      def initialize(radio, &blk)
        @radio = radio
        @blk = blk
      end

      def widget_selected(event)
        @blk.call @radio, event
      end
    end
  end
end
