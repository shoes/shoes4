require 'facets/hash'
require 'shoes/common_methods'
require 'shoes/common/paint'
require 'shoes/common/style'
require 'shoes/line'

module Shoes
  class Shape
    include Shoes::CommonMethods
    include Shoes::Common::Paint
    include Shoes::Common::Style

    attr_reader :blk
    attr_reader :x, :y

    # Creates a new Shoes::Shape
    #
    # This is a composite shape, which has one or more components.
    #
    # Implementation frameworks should pass in any required arguments
    # through the +opts+ hash.
    def initialize(opts = {}, blk = nil)
      @style = Shoes::Common::Paint::DEFAULTS.merge(opts)

      @blk = blk

      @left = @style[:left] || 0
      @top = @style[:top] || 0
      @width = @style[:width] || 0
      @height = @style[:height] || 0

      # Initialize current point to (left, top)
      @x, @y = @left, @top

      # Component shapes
      @components = []

      # GUI
      @gui_opts = @style.delete(:gui)
      gui_init

      instance_eval &@blk unless @blk.nil?
    end

    def left
      @components.map(&:left).min
    end

    def top
      @components.map(&:top).min
    end

    def right
      @components.map { |c| c.left + c.width }.max
    end

    def bottom
      @components.map { |c| c.top + c.height }.max
    end

    def width
      (left - right).abs
    end

    def height
      (top - bottom).abs
    end
  end
end
