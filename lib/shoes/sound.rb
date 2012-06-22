module Shoes
  class Sound
    def initialize(parent, filepath, opts={}, &blk)
      @parent = parent
      @filepath = filepath

      #self.blk = blk

      @gui = Shoes.configuration.backend_for(self, filepath)

      #instance_eval &blk unless blk.nil?

    end

    attr_reader :gui
    attr_reader :filepath
    attr_reader :blk
    attr_reader :parent

    def play
      @gui.play
    end
  end
end
