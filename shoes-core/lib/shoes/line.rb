class Shoes
  class Line
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui, :point_a, :point_b

    style_with :angle, :art_styles, :dimensions, :x2, :y2
    STYLES = { angle: 0 }

    def create_dimensions(point_a, point_b)
      @point_a = point_a
      @point_b = point_b

      enclosing_box_of_line

      style[:x2] = point_b.x
      style[:y2] = point_b.y
    end

    def update_style(new_styles)
      super
      enclosing_box_of_line
    end

    def left=(val)
      set_point_a(:x, val)
    end

    def right=(val)
      set_point_b(:x, val)
    end

    def top=(val)
      set_point_a(:y, val)
    end

    def bottom=(val)
      set_point_b(:y, val)
    end

    alias_method :x2=, :right=
    alias_method :y2=, :bottom=

    def move(x, y, x2=nil, y2=nil)
      @point_a.x = x
      @point_a.y = y
      @point_b.x = x2 if x2
      @point_b.y = y2 if y2
      enclosing_box_of_line
      self
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
      @dimensions = AbsoluteDimensions.new left:   @point_a.x,
                                           top:    @point_a.y,
                                           right:  @point_b.x,
                                           bottom: @point_b.y,
                                           width:  @point_b.x - @point_a.x,
                                           height: @point_b.y - @point_a.y
    end
  end
end
