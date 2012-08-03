require 'shoes/common_methods'

module Shoes
  class Button
    include Shoes::CommonMethods

    def initialize(parent, text = 'Button', opts = {}, blk = nil)
      @parent = parent
      @text = text
      @blk = blk
      @app = opts[:app]

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)

      @gui.height = opts[:height]
      @gui.width  = opts[:width]

      @parent.add_child self
    end

    attr_reader :parent
    attr_reader :blk
    attr_reader :gui
    attr_accessor :text

    def focus
      @gui.focus
    end
  end
end
