class Shoes
  class Border
    include Common::UIElement
    include Common::BackgroundElement
    include Common::Style

    attr_reader :app, :parent, :dimensions, :gui
    style_with :angle, :curve, :stroke, :strokewidth
    STYLES = {angle: 0, curve: 0}


    def initialize(app, parent, color, styles = {})
      @app = app
      @parent = parent
      @dimensions = ParentDimensions.new parent, styles

      style_init(styles, stroke: color)
      @parent.add_child self
      @gui = Shoes.backend_for(self)
    end

    def needs_to_be_positioned?
      false
    end
  end
end
