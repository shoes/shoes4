require 'shoes/common_methods'

module Shoes
  class Button
    include Shoes::CommonMethods

    def initialize(parent, text = 'Button', opts = {}, blk = nil)
      @parent = parent
      @text = text
      @blk = blk
      @app = opts[:app]
      @height = opts[:height]
      @width = opts[:width]

      @gui = Shoes.configuration.backend_for(self, parent.gui, blk)
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
