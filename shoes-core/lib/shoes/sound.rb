class Shoes
  class Sound
    include Common::Inspect

    def initialize(parent, filepath, _opts = {}, &_blk)
      @app    = parent
      @parent = parent
      @filepath = filepath

      @gui = Shoes.backend_for(self)
    end

    attr_reader :app, :gui, :filepath, :parent

    def play
      @gui.play
    end
  end
end
