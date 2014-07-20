class Shoes
  class Background
    include Common::UIElement
    include Common::BackgroundElement
    include Common::Style

    attr_reader :app, :dimensions, :parent, :gui
    style_with :angle, :curve, :fill
    STYLES = {angle: 0, curve: 0}

    def initialize(app, parent, color, styles = {})
      @app    = app
      @parent = parent
      @dimensions = ParentDimensions.new parent, styles

      style_init(styles, fill: color)
      @parent.add_child self
      @gui = Shoes.backend_for(self)
    end

    def needs_to_be_positioned?
      absolutely_positioned?
    end
  end
end
