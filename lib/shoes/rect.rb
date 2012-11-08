module Shoes
  class Rect
    include CommonMethods
    include Common::Style
    include Common::Fill
    include Common::Stroke
    include Common::Clickable

    def initialize(app, left, top, width, height, opts = {}, &blk)
      @app = app
      @left = left
      @top = top
      @width = width
      @height = height
      @corners = opts[:curve] || 0
      @style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS).merge(opts)
      @app.unslotted_elements << self

      @gui = Shoes.backend_for(self, left, top, width, height, opts, &blk)
    end

    attr_reader :app, :hidden
    attr_reader :gui
    attr_reader :corners
  end
end
