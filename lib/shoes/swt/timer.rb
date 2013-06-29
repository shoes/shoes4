class Shoes
  module Swt
    class Timer
      def initialize(dsl, app, blk)
        task = Proc.new do
          unless app.real.disposed?
            blk.call
            app.flush
          end
        end
        ::Swt.display.timer_exec(dsl.n, task)
      end
    end
  end
end
