class Shoes
  module Swt
    class Timer
      def initialize(dsl, app, blk)
        @blk = blk
        task = proc do
          unless app.real.disposed?
            eval_block
          end
        end
        ::Swt.display.timer_exec(dsl.n, task)
      end

      def eval_block
        @blk.call
      end
    end
  end
end
