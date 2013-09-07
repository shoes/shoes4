class Shoes
  class Star
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :gui, :angle, :dimensions, :outer, :inner, :points

    def initialize(app, left, top, points, outer, inner, opts = {}, &blk)
      @app = app
      width = height = outer*2.0
      @dimensions = Dimensions.new left, top, width, height
      @points = points
      @outer = outer
      @inner = inner
      @angle = opts[:angle] || 0
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1
      @app.unslotted_elements << self

      @gui = Shoes.backend_for(self, &blk)

      clickable_options(opts)
    end

    def in_bounds?(x, y)
      dx = width / 2.0
      dy = height / 2.0
      left - dx <= x and x <= right - dx and top - dy <= y and y <= bottom - dy
    end

  end
end
