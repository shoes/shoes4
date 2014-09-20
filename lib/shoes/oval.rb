class Shoes
  class Oval
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui
    style_with :art_styles, :center, :dimensions, :radius
    STYLES = {}

    def initialize(app, parent, left, top, width, height, styles = {}, blk = nil)
      @app                 = app
      @parent              = parent
      style_init(styles)
      @dimensions          = AbsoluteDimensions.new left, top, width, height, @style

      @parent.add_child self
      @gui = Shoes.backend_for(self)

      register_click(styles, blk)
    end
  end
end
