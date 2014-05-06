class Shoes
  class Arc
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :parent, :dimensions
#    style_accessor :angle1, :angle2, :cap, :center, :click, :fill, :height, :left, :radius, :stroke, :strokewidth, :top, :wedge, :width

    def initialize(app, parent, left, top, width, height, angle1, angle2, opts = {})
      @app                 = app
      @parent              = parent
      @dimensions          = Dimensions.new app, left, top, width, height, opts

      style_init     angle1:      opts[:angle1] || angle1,
                     angle2:      opts[:angle2] || angle2, 
                     cap:         opts[:cap]    || :rect, 
                     center:      opts[:center] || false, 
                     click:       opts[:click], 
                     fill:        opts[:fill]   || Common::Style::DEFAULTS[:fill], 
                     height:      opts[:height] || height, 
                     left:        opts[:left]   || left, 
                     radius:      opts[:radius], 
                     stroke:      opts[:stroke] || Common::Style::DEFAULTS[:stroke], 
                     strokewidth: opts[:strokewidth] || Common::Style::DEFAULTS[:strokewidth],
                     top:         opts[:top]    || top,
                     wedge:       opts[:wedge]  || false,
                     width:       opts[:width]  || width

      @parent.add_child self
      @gui = Shoes.backend_for(self, @style)

      clickable_options(opts)
    end

    # @return [Boolean] if fill should be a wedge shape, rather than a chord
    #   Defaults to false
    def wedge?
      @wedge
    end
  end
end
