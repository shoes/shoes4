class Shoes
  module Swt
    class Download

      def initialize(_dsl)
      end

      # This exists to guarantee the callback block for download completion
      # executes on the main UI thread. Without it we get thread access errors.
      def eval_block(result, blk)
        ::Swt.display.asyncExec do
          blk.call result
        end
      end

    end
  end
end
