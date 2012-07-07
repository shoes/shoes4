require 'shoes/common_methods'

module Shoes
  class List_box
    include Shoes::CommonMethods
    attr_reader :items, :gui, :blk, :parent

    def initialize(parent, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @app = opts[:app]

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
      self.items = opts.has_key?(:items) ? opts[:items] : [""]
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
