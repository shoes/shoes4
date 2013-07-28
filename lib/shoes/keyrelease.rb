class Shoes
  class Keyrelease
    def initialize(app, opts = {}, &blk)
      @app = app
      @gui = Shoes.backend_for self, &blk
    end

    attr_reader :app

    def clear
      @gui.clear
    end
  end
end