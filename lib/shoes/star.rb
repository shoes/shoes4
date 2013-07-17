require 'shoes/common/common_methods'
require 'shoes/common/fill'
require 'shoes/common/stroke'
require 'shoes/common/style'
require 'shoes/common/clickable'

class Shoes
  class Star
    include Shoes::CommonMethods
    include Shoes::Common::Fill
    include Shoes::Common::Stroke
    include Shoes::Common::Style
    include Shoes::Common::Clickable

    def initialize(app, left, top, points, outer, inner, opts = {}, &blk)
      @app = app
      @left = left
      @top = top
      @width = @height = outer*2.0
      @points = points
      @outer = outer
      @inner = inner
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1
      @app.unslotted_elements << self

      # GUI
      @gui = Shoes.backend_for(self, left, top, points, outer, inner, opts, &blk)

      clickable_options(opts)
    end

    def in_bounds?(x, y)
      dx = width / 2.0
      dy = height / 2.0
      left - dx <= x and x <= right - dx and top - dy <= y and y <= bottom - dy
    end

    attr_reader :app, :hidden, :gui
  end
end
