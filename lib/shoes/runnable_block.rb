module Shoes

# Runnable is a Java interface(?) that provides a container
# object for SWT::Display.timerExec.  .timerExec() internally
# creates a thread to call runnable.run.  We'll use a class here
# to encapsulate some of the data-passing required in the Thread
# boundary inside .timerExec()
  class RunnableBlock
    def initialize(this, block)
      #@ms_per_frame = ms_per_frame
      @frame = 1
      @this = this
      @block = block
    end

    def actionPerformed(event)
        run(@frame, &@block)
      @frame += 1
    end

    def run frame, &blk
      yield frame
    end
    
    #def init
    #    set_next_timer
    #end

    #def stop
    #  @stop = true
    #end
    #
    #def start
    #  if @stop
    #    @stop = nil
    #    run
    #  end
    #end

    #def run
    #  # This extra call to timerExec is what keeps the "loop" running.
    #  # every execution of #run re-sets the timer for the next execution.
    #  # The timer for the next-loop is started here so that timing between
    #  # loops is not delayed by processing the loop code.  Hopefully the
    #  # @block.call finishes in time!
    #  set_next_timer
    #
    #  @block[@frame]
    #  @frame += 1
    #end
    #def set_next_timer
    #  Swt.display.timer_exec(@ms_per_frame, self) unless @stop
    #end
  end

end
