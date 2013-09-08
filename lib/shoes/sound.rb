class Shoes
  class Sound
    def initialize(parent, filepath, opts={}, &blk)
      @parent = parent
      @filepath = filepath

      @gui = Shoes.configuration.backend_for(self)
    end

    attr_reader :gui, :filepath, :parent

    def play
      @gui.play
    end
  end
end
