class Shoes
  class Sound
    include Common::Inspect

    def initialize(parent, filepath, _opts = {}, &_blk)
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
