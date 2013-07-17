class Shoes
  class Background
    include CommonMethods
    include Common::Style
    include Common::Fill
    include Common::Stroke

    def initialize(app, parent, color, opts = {}, blk = nil)
      @app = app
      @parent = parent

      @left = opts[:left] || 0
      @top = opts[:top] || 0
      @width = opts[:width] || 0
      @height = opts[:height] || 0
      @corners = opts[:curve] || 0
      opts[:fill] = color
      @style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS).merge(opts)

      @gui = Shoes.backend_for(self, left, top, width, height, opts, &blk)
    end

    attr_reader :app, :hidden
    attr_reader :gui, :parent
    attr_reader :corners
  end
end
