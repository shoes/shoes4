class Shoes
  class Rect
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :gui, :dimensions, :parent
    style_with :angle, :art_styles, :curve, :dimensions


    def initialize(app, parent, left, top, width, height, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init(styles)
      @dimensions = AbsoluteDimensions.new left, top, width, height, @style
      @parent.add_child self
      @gui = Shoes.backend_for(self)
      register_click(@style, blk)
    end
  end
end
