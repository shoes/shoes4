# frozen_string_literal: true

class Shoes
  class Animation
    include Common::Inspect

    # Creates a new Animation.
    #
    # @overload initialize(opts, &blk)
    #   @param [Hash] opts An options hash
    #   @param [Proc] blk A block of code to be executed for each
    #     animation frame
    #   @option opts [Integer] :framerate (24) The framerate (frames per second)
    #   @option opts [Shoes::App] :app The current Shoes app
    def initialize(app, opts, blk)
      @style = opts
      @framerate = @style[:framerate] || 10
      @app = app
      @blk = @app.current_slot.create_bound_block(blk)
      @current_frame = 0
      @stopped = false
      @gui = Shoes.backend_for(self)
    end

    attr_reader :current_frame, :framerate, :blk, :app

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

    def remove
      @removed = true
    end

    def removed?
      @removed
    end

    # Increments the current frame by 1
    #
    # @return [Integer] The new current frame
    def increment_frame
      @current_frame += 1
    end
  end
end
