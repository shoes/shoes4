module Shoes
  class Animation

    # Creates a new Animation.
    #
    # @overload initialize(opts, &blk)
    #   @param [Hash] opts An options hash
    #   @param [Proc] blk A block of code to be executed for each
    #     animation frame
    #   @option opts [Integer] :framerate (24) The framerate (frames per second)
    def initialize opts, blk
      @style = opts
      @framerate = @style[:framerate] || 24
      @app = opts[:app]
      @blk = blk
      @current_frame = 0
      @stopped = false
      @gui = Shoes.configuration.backend_for(self, @app, @blk)
    end

    attr_reader :current_frame
    attr_reader :framerate

    def start
      @stopped = false
    end

    def stop
      @stopped = true
    end

    def stopped?
      @stopped
    end

    def toggle
     @stopped = !@stopped
    end

    # Increments the current frame by 1
    #
    # @return [Integer] The new current frame
    def increment_frame
      @current_frame += 1
    end
  end
end
