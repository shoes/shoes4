require 'shoes/common_methods'

module Shoes
  class EditBox
    include Shoes::CommonMethods

    attr_reader :gui, :blk, :parent, :text, :opts

    def initialize(parent, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @app = opts[:app]
      @opts = opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
      @parent.add_child self
    end

    def focus
      @gui.focus
    end
    
    def text
      @gui.text
    end

    def text=(value)
      @gui.text = value
    end
  end
end
