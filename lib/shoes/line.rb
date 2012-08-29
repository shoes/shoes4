require 'shoes/common_methods'
require 'shoes/common/fill'
require 'shoes/common/stroke'
require 'shoes/common/style'

module Shoes
  class Line
    include Shoes::CommonMethods
    include Shoes::Common::Stroke
    include Shoes::Common::Style

    def initialize(point_a, point_b, opts = {})
      @point_a = point_a
      @point_b = point_b
      @left = point_a.x < point_b.x ? point_a.x : point_b.x
      @top = point_a.y < point_b.y ? point_a.y : point_b.y
      @width = (point_a.x - point_b.x).abs
      @height = (point_a.y - point_b.y).abs

      @style = Shoes::Common::Stroke::DEFAULTS.merge(opts)

      # GUI
      gui_opts = @style.clone
      gui_opts[:width] = @width
      gui_opts[:height] = @height
      gui_opts[:app]    = opts[:app].gui

      @gui = Shoes.configuration.backend_for(self, @point_a, @point_b, gui_opts)
    end
  end
end
