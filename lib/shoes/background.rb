require 'shoes/common_methods'
require 'shoes/color'

module Shoes
  class Background
    include Shoes::CommonMethods

    attr_reader :parent, :blk, :gui
    attr_reader :color, :opts, :curve
    attr_accessor :width, :height
    alias :fill :color

    def initialize(parent, color, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @opts = opts
      @app = opts[:app]

      @color = color
      @color = opts[:fill] if opts.has_key? :fill
      @curve = opts[:curve] ? opts[:curve] : 0

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
    end
  end
end
