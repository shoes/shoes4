class Shoes
  class Background
    include Common::UIElement
    include Common::BackgroundElement
    include Common::Style
    include Common::Fill
    include Common::Stroke

    attr_reader :app, :gui, :parent, :corners, :angle, :dimensions

    def initialize(app, parent, color, opts = {}, blk = nil)
      @app    = app
      @parent = parent
      @dimensions = ParentDimensions.new parent, opts
      @corners    = opts[:curve] || 0
      @angle      = opts[:angle] || 0
      opts[:fill] = color

      @style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS).merge(opts)
      parent.add_child self

      @gui = Shoes.backend_for(self, opts, &blk)
    end

    def needs_to_be_positioned?
      absolutely_positioned?
    end
  end
end
