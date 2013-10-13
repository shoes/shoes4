class Shoes
  class Rect
    include CommonMethods
    include Common::Style
    include Common::Fill
    include Common::Stroke
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :gui, :corners, :dimensions, :angle

    def initialize(app, left, top, width, height, opts = {}, &blk)
      @app = app
      @dimensions = AbsoluteDimensions.new left, top, width, height, app
      @corners = opts[:curve] || 0
      @angle = opts[:angle] || app.rotate
      @style = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1
      @app.unslotted_elements << self

      @gui = Shoes.backend_for(self, opts, &blk)
      clickable_options(opts)
    end
  end
end
