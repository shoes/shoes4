module Shoes
  class Keypress
    def initialize opts, &blk
      @app = opts[:app]
      @gui = Shoes.backend_for self, &blk
    end
    
    attr_reader :app

    def clear
      @gui.clear
    end
  end
end
