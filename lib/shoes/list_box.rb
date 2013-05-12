require 'shoes/common_methods'
require 'shoes/common/changeable'

module Shoes
  class ListBox
    include Shoes::CommonMethods
    include Shoes::Common::Changeable

    attr_reader :items, :gui, :blk, :parent, :opts

    def initialize(app, parent, opts = {}, blk = nil)
      @app    = app
      @parent = parent
      @blk    = blk
      @opts   = opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      self.items = opts.has_key?(:items) ? opts[:items] : [""]
      @parent.add_child self

      self.change &blk if blk
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
