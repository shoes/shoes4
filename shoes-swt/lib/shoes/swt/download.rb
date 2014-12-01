class Shoes
  module Swt
    class Download
      attr_accessor :busy
      def initialize(_dsl)
        @busy = false
      end

      # This exists to guarantee the callback block for download completion
      # executes on the main UI thread. Without it we get thread access errors.
      def eval_block(blk, result)
        ::Swt.display.asyncExec do
          blk.call result
          @busy = false
        end
      end

      def busy?
        @busy
      end
    end
  end
end
