require 'shoes/common_methods'

module Shoes
  class Progress
    include Shoes::CommonMethods

    attr_reader :parent, :blk, :gui, :opts
    attr_reader :fraction

    def initialize(parent, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @app = opts[:app]
      @opts = opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
      @parent.add_child self

      @fraction = 0.0
    end

    def fraction=(value)
      @fraction = value
      @gui.fraction = value
    end
  end
end
