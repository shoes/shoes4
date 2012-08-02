require 'shoes/common_methods'
require 'shoes/color'

module Shoes
  class Border
    DEFAULT_BORDER_SIZE = 1
    include Shoes::CommonMethods

    attr_reader :parent, :blk, :gui
    attr_reader :color, :opts, :curve, :strokewidth
    attr_accessor :width, :height
    alias :stroke :color

    def initialize(parent, color, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @opts = opts
      @app = opts[:app]

      @color = opts[:stroke] || color
      @curve = opts[:curve] || 0
      @strokewidth = opts[:strokewidth] || DEFAULT_BORDER_SIZE

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
    end
  end
end
