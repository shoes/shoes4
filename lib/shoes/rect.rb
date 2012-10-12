module Shoes
  class Rect
    include CommonMethods
    include Common::Style
    include Common::Fill
    include Common::Stroke

    def initialize(app, left, top, width, height, opts = {}, &blk)
      @app = app
      @left = left
      @top = top
      @width = width
      @height = height
      @corners = opts[:curve] || 0
      @style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS).merge(opts)

      @gui = Shoes.backend_for(self, left, top, width, height, opts, &blk)
    end

    attr_reader :app
    attr_reader :gui
    attr_reader :corners
  end
end
