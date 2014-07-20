class Shoes
  class Border
    include Common::UIElement
    include Common::BackgroundElement
    include Common::Style
    include Common::Fill
    include Common::Stroke

    attr_reader :app, :gui, :parent, :corners, :angle, :opts, :dimensions

    def initialize(app, parent, color, opts = {}, blk = nil)
      @app = app
      @parent = parent

      @dimensions = ParentDimensions.new parent, opts
      @corners = opts[:curve] || 0
      @angle = opts[:angle] || 0

      opts[:stroke] = color
      parent.add_child self

      @style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1

      @gui = Shoes.backend_for(self, opts, &blk)
    end

    def needs_to_be_positioned?
      false
    end
  end
end
