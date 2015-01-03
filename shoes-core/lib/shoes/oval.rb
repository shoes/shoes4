class Shoes
  class Oval
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui
    style_with :art_styles, :center, :common_styles, :dimensions, :radius

    def initialize(app, parent, left, top, width, height, styles = {}, blk = nil)
      @app = app
      @parent = parent

      left ||= styles[:left]
      top ||= styles[:top]
      width ||= styles[:diameter] || styles[:width] || (styles[:radius] || 0) * 2
      height ||= styles[:height] || width

      style_init styles
      @dimensions = AbsoluteDimensions.new left, top, width, height, @style
      @parent.add_child self
      @gui = Shoes.backend_for self
      register_click blk
    end
  end
end
