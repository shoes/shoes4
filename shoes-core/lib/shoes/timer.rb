class Shoes
  class Timer
    include Common::Inspect

    def initialize(app, n = 1000, &blk)
      @app, @n, @blk = app, n, blk
      @gui = Shoes.configuration.backend_for(self, @app.gui, @blk)
    end

    attr_reader :n, :gui
  end
end
