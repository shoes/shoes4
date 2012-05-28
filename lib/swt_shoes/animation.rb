require 'shoes/timer_base'
require 'shoes/runnable_block'

module SwtShoes
  module Animation
    def gui_init
      # Wrap the animation block so we can count frames.
      # Note that the task re-calls itself on each run.
      task = Proc.new do
        @blk.call(@current_frame)
        @current_frame += 1
        @gui_container.redraw
        Swt.display.timer_exec 1000 / @framerate, task
      end
      Swt.display.timer_exec 1000 / @framerate, task
    end

    #def stop
    #end

    #def start
    #end
  end
end

module Shoes
  class Animation
    include SwtShoes::Animation
  end
end
