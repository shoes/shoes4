require 'shoes/common_methods'

module Shoes
  class ListBox
    include Shoes::CommonMethods
    attr_reader :items, :gui, :blk, :parent, :opts

    def initialize(parent, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @app = opts[:app]
      @opts = opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
      self.items = opts.has_key?(:items) ? opts[:items] : [""]
      @parent.add_child self
    end

    def items=(values)
      @items = values
      @gui.update_items values
    end

    def text
      @gui.text
    end

    def choose(item)
      @gui.choose item
    end
  end
end
