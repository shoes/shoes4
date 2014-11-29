class Shoes
  class Timer
    include Common::Inspect

    def initialize(app, n = 1000, &blk)
      @app, @n, @blk = app, n, blk

      # We want to execute in the context of the slot where we were initially
      # called, so capture that outside the proc and execute through that slot.
      slot = @app.current_slot
      wrapped_block = Proc.new do
        slot.eval_block(@blk)
      end

      @gui = Shoes.configuration.backend_for(self, @app.gui, wrapped_block)
    end

    attr_reader :n, :gui
  end
end
