class Shoes
  class Line
    include Common::UIElement
    include Common::Stroke
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui
    style_with :angle, :art_styles, :dimensions, :point_a, :point_b

    def initialize(app, parent, point_a, point_b, styles = {}, blk = nil)
      @app                 = app
      @parent              = parent

      style_init(styles, point_a: point_a, point_b: point_b)
      enclosing_box_of_line

      @parent.add_child self
      @gui = Shoes.backend_for(self)

      register_click(styles, blk)
    end

    def update_style(new_styles)
      super
      enclosing_box_of_line
    end

    def enclosing_box_of_line
      @dimensions = AbsoluteDimensions.new left:   point_a.left(point_b),
                                           top:    point_a.top(point_b),
                                           width:  point_a.width(point_b),
                                           height: point_a.height(point_b)
    end
  end
end
