require 'shoes/common_methods'
require 'shoes/color'

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

      Shoes::Background.new(parent, color, bottom_coords)
      Shoes::Background.new(parent, color, top_coords)
      Shoes::Background.new(parent, color, left_coords)
      Shoes::Background.new(parent, color, right_coords)
    end

    def left_coords
      opts = Hash.new
      opts[:app] = @app
      opts[:width] = @strokewidth
      opts[:left] = 0
      opts
    end

    def right_coords
      opts = Hash.new
      opts[:app] = @app
      opts[:width] = @strokewidth
      opts[:right] = 0
      opts
    end

    def top_coords
      opts = Hash.new
      opts[:app] = @app
      opts[:height] = @strokewidth
      opts[:top] = 0
      opts
    end

    def bottom_coords
      opts = Hash.new
      opts[:app] = @app
      opts[:bottom] = 0
      opts[:top] = @app.height - @strokewidth
      opts
    end
  end
end
