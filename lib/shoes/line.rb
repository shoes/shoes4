require 'shoes/common_methods'
require 'shoes/common/paint'
require 'shoes/common/style'

module Shoes
  class Line
    include Shoes::CommonMethods
    include Shoes::Common::Paint
    include Shoes::Common::Style

    def initialize(x1, y1, x2, y2, opts = {})
      @left = x1 < x2 ? x1 : x2
      @top = y1 < y2 ? y1 : y2
      @width = (x1 - x2).abs
      @height = (y1 - y2).abs

      @style = Shoes::Common::Paint::DEFAULTS.merge(opts)

      # GUI
      @gui_opts = @style.delete(:gui)
      gui_init
    end
  end
end
