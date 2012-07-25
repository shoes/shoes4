require 'shoes/common_methods'

module Shoes
  class Image
    include Shoes::CommonMethods

    attr_reader :parent, :blk, :gui
    attr_reader :file_path

    def initialize(parent, file_path, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @app = opts[:app]

      @file_path = file_path
      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
    end
  end
end
