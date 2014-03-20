class Shoes
  module Swt
    class Download

      def initialize(_dsl)
      end

      # This exists to guarantee the callback block for download completion
      # executes on the main UI thread. Without it we get thread access errors.
      def eval_block(blk, result)

        ::Swt.display.asyncExec do
          blk.call result
          $async_has_finished = true
        end
      end

    end
  end
end
