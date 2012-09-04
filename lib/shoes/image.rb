require 'shoes/common_methods'

module Shoes
  class Image
    include Shoes::CommonMethods

    attr_reader :parent, :blk, :gui, :app
    attr_reader :file_path

    def initialize(parent, file_path, opts = {}, blk = nil)
      @left = opts[:left] ? opts[:left] : 0
      @top = opts[:top] ? opts[:top] : 0
      @parent = parent
      @blk = blk
      @app = opts[:app]

      @file_path = file_path
      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
    end
  end
end
