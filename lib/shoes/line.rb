class Shoes
  class Line
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui, :point_a, :point_b
    style_with :angle, :art_styles, :dimensions, :x2, :y2

    def initialize(app, parent, point_a, point_b, styles = {}, blk = nil)
      @app     = app
      @parent  = parent
      @point_a = point_a
      @point_b = point_b

      style_init(styles, x2: point_b.x, y2: point_b.y)
      enclosing_box_of_line

      @parent.add_child self
      @gui = Shoes.backend_for(self)

      register_click(styles, blk)
    end

    def update_style(new_styles)
      super
      enclosing_box_of_line
    end

    def left=(val)
      @point_a.x < @point_b.x ? @point_a.x = val : set_point_b(val, y2)
      enclosing_box_of_line
    end

    def right=(val)
      @point_a.x > @point_b.x ? @point_a.x = val : set_point_b(val, y2)
      enclosing_box_of_line
    end

    def top=(val)
      @point_a.y < @point_b.y ? @point_a.y = val : set_point_b(x2, val)
      enclosing_box_of_line
    end

    def bottom=(val)
      @point_a.y > @point_b.y ? @point_a.y = val : set_point_b(x2, val)
      enclosing_box_of_line
    end

    def x2=(val)
      set_point_b(val, y2)
      enclosing_box_of_line
    end

    def y2=(val)
      set_point_b(x2, val)
      enclosing_box_of_line
    end

    private

    def set_point_b(x_val, y_val)
      @point_b.x = x_val unless x2 == x_val
      @point_b.y = y_val unless y2 == y_val
      @style[:x2] = x_val unless @style[:x2] == x_val
      @style[:y2] = y_val unless @style[:y2] == y_val
    end

    def enclosing_box_of_line
      left = @point_a.left(@point_b)
      top = @point_a.top(@point_b)
      width = @point_a.width(@point_b)
      height = @point_a.height(@point_b)
      right = left + width
      bottom = top + height

      @dimensions = AbsoluteDimensions.new left:   left,
                                           top:    top,
                                           right:  right,
                                           bottom: bottom,
                                           width:  width,
                                           height: height
    end
  end
end
