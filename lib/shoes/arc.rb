class Shoes
  class Arc
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :parent, :dimensions
    style_with :angle1, :angle2, :art_styles, :cap, :center, :dimensions, :radius, :wedge

    def initialize(app, parent, left, top, width, height, angle1, angle2, opts = {})
      @app                 = app
      @parent              = parent
      @dimensions          = Dimensions.new app, left, top, width, height, opts
      
      style_init
      @style[:angle1] = angle1
      @style[:angle2] = angle2
      @style.merge!(opts)

      @parent.add_child self
      @gui = Shoes.backend_for(self, @style)

      clickable_options(opts)
    end

    # @return [Boolean] if fill should be a wedge shape, rather than a chord
    #   Defaults to false
    def wedge?
      @style[:wedge]
    end
  end
end
