require 'shoes/common_methods'

module Shoes
  class Check
    include Shoes::CommonMethods

    attr_reader :parent
    attr_reader :blk
    attr_reader :gui

    def initialize(parent, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @app = opts[:app]

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
