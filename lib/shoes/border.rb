require 'shoes/common_methods'

module Shoes
  class Border
    DEFAULT_BORDER_SIZE = 10

    include Shoes::CommonMethods

    attr_reader :parent, :blk, :gui
    attr_reader :color

    def initialize(parent, color, opts = {}, blk = nil)
      @parent = parent
      @blk = blk
      @app = opts[:app]

      @strokewidth = opts[:strokewidth] if opts.has_key? :strokewidth
      @strokewidth ||= DEFAULT_BORDER_SIZE

      @color = color

      Shoes::Background.new(parent, color, middle_box_coords, nil)
    end

    # Returns a hash containing left, right top and bottom
    def middle_box_coords()
      coords = Hash.new
      coords[:app] = @app
      coords[:bottom] = @strokewidth
      coords[:top] = @strokewidth
      coords[:left] = @strokewidth
      coords[:right] = @strokewidth
      coords
    end
 end
end
