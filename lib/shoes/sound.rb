module Shoes
  class Sound
    def initialize(gui_container, filepath, opts={}, &blk)
      self.gui_container = gui_container
      self.filepath = filepath

      #self.blk = blk

      gui_sound_init

      #instance_eval &blk unless blk.nil?

    end

    attr_accessor :gui_container
    attr_accessor :filepath, :blk

    def play
      gui_sound_play
    end
  end
end
