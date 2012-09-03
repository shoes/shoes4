module Shoes
  class Rect
    include CommonMethods
    include Common::Style
    include Common::Fill
    include Common::Stroke

    def initialize(app, left, top, width, height, opts = {})
      @app = app
      @left = left
      @top = top
      @width = width
      @height = height
      @corners = opts[:corners] || 0
      @style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS).merge(opts)

      @gui = Shoes.backend_for(self, left, top, width, height, opts)
    end

    attr_reader :app
    attr_reader :gui
    attr_reader :corners
  end
end
