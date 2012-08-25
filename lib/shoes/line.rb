require 'shoes/common_methods'
require 'shoes/common/fill'
require 'shoes/common/stroke'
require 'shoes/common/style'

module Shoes
  class Line
    include Shoes::CommonMethods
    include Shoes::Common::Stroke
    include Shoes::Common::Style

    def initialize(x1, y1, x2, y2, opts = {})
      @left = x1 < x2 ? x1 : x2
      @top = y1 < y2 ? y1 : y2
      @width = (x1 - x2).abs
      @height = (y1 - y2).abs

      @style = Shoes::Common::Stroke::DEFAULTS.merge(opts)

      # GUI
      values = @style.clone
      values[:left]   = @left
      values[:top]    = @top
      values[:width]  = @width
      values[:height] = @height

      @gui = Shoes.configuration.backend_for(self, values)
    end
  end
end
