# frozen_string_literal: true

class Shoes
  module Swt
    class Timer
      def initialize(dsl, app, blk)
        @blk = blk
        task = proc do
          eval_block unless app.real.disposed?
        end
        ::Swt.display.timer_exec(dsl.n, task)
      end

      def eval_block
        @blk.call
      end
    end
  end
end
