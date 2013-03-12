require 'shoes/common_methods'

module Shoes
  class Radio
    include Shoes::CommonMethods
    attr_reader :gui, :blk, :parent

    def initialize(parent, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @app = opts[:app]
      @checked = false
      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
      @parent.add_child self
    end

    def checked?
      @gui.checked?
    end

    def checked=(value)
      @gui.checked = value
    end

    def focus
      @gui.focus
    end

    def click
      @blk.call
    end
  end
end
