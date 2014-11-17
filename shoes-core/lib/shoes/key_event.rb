class Shoes
  class KeyEvent
    def initialize(app, &blk)
      @app = app
      @gui = Shoes.backend_for self, &blk
    end

    attr_reader :app

    def remove
      @gui.remove
    end
  end

  class Keypress < KeyEvent; end
  class Keyrelease < KeyEvent; end
end
