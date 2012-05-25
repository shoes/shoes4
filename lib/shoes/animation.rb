require 'shoes/timer_base'
#require 'runnable_block'

module Shoes
  class Animation < TimerBase

    import javax.swing.Timer

    attr_reader :jtimer

    def initialize this, fps, &blk
      ms_per_frame = 1000 / fps

      if block_given?
        @runnable = RunnableBlock.new(this, blk)
        @jtimer = Timer.new(ms_per_frame, @runnable )

        #@runnable.init
        @jtimer.start
      end
    end

    def stop
      #@runnable.stop
      @jtimer.stop
    end

    def start
      #@runnable.start
      @jtimer.start
    end

  end
end
