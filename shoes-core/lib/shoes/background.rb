class Shoes
  class Background
    include Common::BackgroundElement
    include Common::Fill
    include Common::Style

    style_with :angle, :common_styles, :curve, :dimensions, :fill
    STYLES = { angle: 0, curve: 0 }.freeze

    def before_initialize(styles, color)
      styles[:fill] = color
    end
  end
end
