class Shoes
  class Arc
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :parent, :dimensions
    style_with :angle1, :angle2, :art_styles, :center, :dimensions, :radius, :wedge
    STYLES = {wedge: false}

    def initialize(app, parent, left, top, width, height, angle1, angle2, styles = {})
      @app                 = app
      @parent              = parent
      @dimensions          = Dimensions.new parent, left, top, width, height, styles
      
      style_init(styles, angle1: angle1, angle2: angle2)
      @parent.add_child self
      @gui = Shoes.backend_for(self)

      clickable_options(styles)
    end
  end
end
