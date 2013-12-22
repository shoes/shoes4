class Shoes
  class Arc
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :angle1, :angle2, :dimensions, :parent

    def initialize(app, parent, left, top, width, height, angle1, angle2, opts = {})
      @app                 = app
      @dimensions          = Dimensions.new app, left, top, width, height, opts
      @angle1, @angle2     = angle1, angle2
      @wedge               = opts[:wedge] || false
      default_style        = Common::Fill::DEFAULTS.merge(Common::Stroke::DEFAULTS)
      @style               = default_style.merge(opts)
      @style[:strokewidth] ||= @app.style[:strokewidth] || 1
      @parent              = parent

      @parent.add_child self

      @gui = Shoes.backend_for(self, opts)

      clickable_options(opts)
    end

    # @return [Boolean] if fill should be a wedge shape, rather than a chord
    #   Defaults to false
    def wedge?
      @wedge
    end
  end
end
