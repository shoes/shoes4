require 'shoes/timer_base'
#require 'runnable_block'

module Shoes
  class Animation < TimerBase

    # Creates a new Animation.
    #
    # @overload initialize(gui_container, framerate, &blk)
    #   @param [Object] gui_container The gui element that is the parent of this animation
    #   @param [Integer] framerate The framerate (frames per second).
    #     Defaults to 24
    #   @param [Proc] blk A block of code to be executed for each
    #     animation frame
    # @overload initialize(gui_container, opts, &blk)
    #   @param gui_container The gui element that is the parent of this animation
    #   @param [Hash] opts An options hash
    #   @param [Proc] blk A block of code to be executed for each
    #     animation frame
    #   @option opts [Integer] :framerate (24) The framerate (frames per second)
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
