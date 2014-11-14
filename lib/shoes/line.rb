class Shoes
  class Line
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui, :point_a, :point_b

    style_with :angle, :art_styles, :dimensions, :x2, :y2
    STYLES = { angle: 0 }

    def initialize(app, parent, point_a, point_b, styles = {}, blk = nil)
      @app     = app
      @parent  = parent
      @point_a = point_a
      @point_b = point_b

      style_init styles, x2: point_b.x, y2: point_b.y
      enclosing_box_of_line

      @parent.add_child self
      @gui = Shoes.backend_for self
      register_click blk
    end

    def update_style(new_styles)
      super
      enclosing_box_of_line
    end

    def left=(val)
      @point_a.x < @point_b.x ? set_point_a(:x, val) : set_point_b(:x, val)
    end

    def right=(val)
      @point_a.x > @point_b.x ? set_point_a(:x, val) : set_point_b(:x, val)
    end

    def top=(val)
      @point_a.y < @point_b.y ? set_point_a(:y, val) : set_point_b(:y, val)
    end

    def bottom=(val)
      @point_a.y > @point_b.y ? set_point_a(:y, val) : set_point_b(:y, val)
    end

    def x2=(val)
      set_point_b(:x, val)
    end

    def y2=(val)
      set_point_b(:y, val)
    end

    private

    def set_point_a(which, val)
      @point_a.x = val if which == :x
      @point_a.y = val if which == :y
      enclosing_box_of_line
    end

    def set_point_b(which, val)
      @point_b.x = val if which == :x
      @point_b.y = val if which == :y
      style(x2: val) if which == :x
      style(y2: val) if which == :y
      enclosing_box_of_line
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
