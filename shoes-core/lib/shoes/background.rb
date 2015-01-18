class Shoes
  class Background
    include Common::UIElement
    include Common::BackgroundElement
    include Common::Style

    attr_reader :app, :parent, :dimensions, :gui

    style_with :angle, :common_styles, :curve, :dimensions, :fill
    STYLES = { angle: 0, curve: 0 }

    def before_initialize(styles, color)
      styles[:fill] = color
    end

    def create_dimensions(*_)
      @dimensions = ParentDimensions.new @parent, @style
    end
  end
end
