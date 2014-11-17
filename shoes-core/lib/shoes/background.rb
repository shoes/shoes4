class Shoes
  class Background
    include Common::UIElement
    include Common::BackgroundElement
    include Common::Style

    attr_reader :app, :parent, :dimensions, :gui
    style_with :angle, :common_styles, :curve, :dimensions, :fill
    STYLES = { angle: 0, curve: 0 }

    def initialize(app, parent, color, styles = {})
      @app = app
      @parent = parent
      style_init styles, fill: color
      @dimensions = ParentDimensions.new parent, @style
      @parent.add_child self
      @gui = Shoes.backend_for self
    end

    def needs_to_be_positioned?
      absolutely_positioned?
    end
  end
end
