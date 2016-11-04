class Shoes
  class Border
    include Common::UIElement
    include Common::BackgroundElement
    include Common::Fill
    include Common::Stroke
    include Common::Style

    style_with :angle, :common_styles, :curve, :dimensions, :stroke, :strokewidth
    STYLES = { angle: 0, curve: 0 }.freeze

    def before_initialize(styles, color)
      styles[:stroke] = color
    end
  end
end
