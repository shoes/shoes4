class Shoes
  module Swt
    class Download

      def initialize(_dsl)
        #A fake async_queue to help us not overload it.
        @async_queue = []
      end

      # This exists to guarantee the callback block for download completion
      # executes on the main UI thread. Without it we get thread access errors.
      def eval_block(blk, result)
        ::Swt.display.asyncExec do
          blk.call result
          @async_queue.shift
        end
      end

      def async_queue
        @async_queue
      end

    end
  end
end
