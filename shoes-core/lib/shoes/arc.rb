class Shoes
  class Arc
    include Common::UIElement
    include Common::Fill
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include Common::Hover

    style_with :angle1, :angle2, :art_styles, :center, :common_styles, :dimensions, :radius, :wedge
    STYLES = { wedge: false }.freeze

    def before_initialize(styles, left, top, width, height, angle1, angle2)
      styles[:angle1] = angle1
      styles[:angle2] = angle2
    end

    def create_dimensions(left, top, width, height, angle1, angle2)
      @dimensions = Dimensions.new parent, left, top, width, height, @style
    end

    def wedge?
      wedge
    end
  end
end
