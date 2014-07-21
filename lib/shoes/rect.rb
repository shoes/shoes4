class Shoes
  class Rect
    include Common::UIElement
    include Common::Style
    include Common::Fill
    include Common::Stroke
    include Common::Clickable

    attr_reader :app, :gui, :corners, :dimensions, :angle, :parent

    def initialize(app, parent, left, top, width, height, opts = {}, blk = nil)
      @app                 = app
      @dimensions          = AbsoluteDimensions.new left, top, width, height, opts
      @corners             = opts[:curve] || 0
      @angle               = opts[:angle] || app.rotate
      @style               = Common::Fill::DEFAULTS.merge(
                             Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= 1
      @parent              = parent

      @parent.add_child self

      @gui = Shoes.backend_for(self, opts)
      register_click(opts, blk)
    end
  end
end
