module Shoes
  class Flow
    include Shoes::ElementMethods

    attr_reader :parent, :gui
    attr_reader :blk
    attr_accessor :width, :height, :margin


    def initialize(parent, opts={}, blk = nil)
      @parent = parent

      self.width = opts[:width]
      self.height = opts[:height]
      self.margin = opts[:margin]
      @app = opts[:app]

      @blk = blk

      @gui = Shoes.configuration.backend_for(self, @parent.gui)

      instance_eval &blk unless blk.nil?
    end
  end
end
