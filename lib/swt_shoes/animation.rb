require 'shoes/timer_base'
require 'shoes/runnable_block'

module Shoes
  class Animation < TimerBase

    def initialize fps, &blk
      ms_per_frame = 1000 / fps

      if block_given?
        @runnable = RunnableBlock.new(ms_per_frame, blk)

        @runnable.init
      end
    end

    def stop
      @runnable.stop
    end

    def start
      @runnable.start
    end

  end
end
