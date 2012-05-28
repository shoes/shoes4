require 'shoes/timer_base'
#require 'runnable_block'

module Shoes
  class Animation < TimerBase

    # Creates a new Animation.
    #
    # Arguments
    #
    # gui_container - The gui element that is the parent of this animation
    # opts          - Either an integer, representing the framerate (frames per
    #                 second) of the animation, or a Hash of options. Right now,
    #                 framerate is the only supported option. If no framerate
    #                 is provided, the default is 24.
    # blk           - A block of code to be executed for each frame of the
    #                 animation.
    #
    def initialize gui_container, *opts, &blk
      @current_frame = 0
      @style = opts.last.class == Hash ? opts.pop : {}
      @style[:framerate] = opts.first if opts.length == 1
      @framerate = @style[:framerate] || 24
      super gui_container, @style, &blk
    end

    attr_reader :framerate
  end
end
