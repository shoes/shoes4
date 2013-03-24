require 'shoes/common_methods'
require 'shoes/common/changeable'

module Shoes
  class EditLine
    include Shoes::CommonMethods
    include Shoes::Common::Changeable

    attr_reader :gui, :blk, :parent, :text, :opts

    def initialize(parent, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @app = opts[:app]
      @opts = opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self
      self.change &blk if blk
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
