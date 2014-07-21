class Shoes
  class Line
    include Common::UIElement
    include Common::Stroke
    include Common::Style
    include Common::Clickable

    attr_reader :app, :point_a, :point_b, :angle, :dimensions, :gui, :parent


    def initialize(app, parent, point_a, point_b, opts = {}, blk = nil)
      @app                 = app
      @style               = Shoes::Common::Stroke::DEFAULTS.merge(opts)
      @style[:strokewidth] ||= 1
      @angle               = opts[:angle] || 0
      @point_a             = point_a
      @point_b             = point_b
      @parent              = parent

      enclosing_box_of_line

      gui_opts = @style.clone
      @parent.add_child self

      @gui = Shoes.backend_for(self, gui_opts)

      register_click(opts, blk)
    end

    def enclosing_box_of_line
      @dimensions = AbsoluteDimensions.new left:   @point_a.left(@point_b),
                                           top:    @point_a.top(@point_b),
                                           width:  @point_a.width(@point_b),
                                           height: @point_a.height(@point_b)
    end
  end
end
