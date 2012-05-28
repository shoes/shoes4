module Shoes
  class TimerBase
    def initialize gui_container, opts, &blk
      @gui_container = gui_container
      @blk = blk
      @app = opts[:app]
      @stopped = false
      gui_init
    end

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
  end
end
