class Shoes
  class Line
    include CommonMethods
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :point_a, :point_b, :angle, :dimensions, :gui


    def initialize(app, point_a, point_b, opts = {})
      @app = app

      @style = Shoes::Common::Stroke::DEFAULTS.merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1
      @angle = opts[:angle] || 0

      @point_a = point_a
      @point_b = point_b
      enclosing_box_of_line

      gui_opts = @style.clone
      @app.unslotted_elements << self

      @gui = Shoes.backend_for(self, gui_opts)

      clickable_options(opts)
    end

    def enclosing_box_of_line
      @dimensions = AbsoluteDimensions.new left:   @point_a.left(@point_b),
                                           top:    @point_a.top(@point_b),
                                           width:  @point_a.width(@point_b),
                                           height: @point_a.height(@point_b)
    end

    def move(x, y)
      self.left = x
      self.top = y
      @gui.update_position
      self
    end
  end
end
