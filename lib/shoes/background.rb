class Shoes
  class Background
    include CommonMethods
    include Common::Style
    include Common::Fill
    include Common::Stroke
    include DimensionsDelegations

    attr_reader :app, :gui, :parent, :corners, :angle, :dimensions

    def initialize(app, parent, color, opts = {}, blk = nil)
      @app    = app
      @parent = parent
      @dimensions = Dimensions.new opts
      @corners    = opts[:curve] || 0
      @angle      = opts[:angle] || 0
      opts[:fill] = color

      @style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS).merge(opts)
      parent.contents << self

      @gui = Shoes.backend_for(self, opts, &blk)
    end

  end
end
