require 'shoes/common_methods'
require 'shoes/common/changeable'

module Shoes
  class EditBox
    include Shoes::CommonMethods
    include Shoes::Common::Changeable

    attr_reader :gui, :blk, :parent, :text, :opts

    def initialize(app, parent, text, opts = {}, blk = nil)
      @app = app
      @parent = parent
      @opts = opts
      @blk = blk

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      self.text = text
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
