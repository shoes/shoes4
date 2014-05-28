class Shoes
  class Oval
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :dimensions, :parent, :gui
    style_with :angle, :art_styles, :center, :radius

    def initialize(app, parent, left, top, width, height, styles = {}, &blk)
      @app                 = app
      @dimensions          = AbsoluteDimensions.new left, top, width, height, styles
      @parent              = parent
      
      style_init(styles)
      @parent.add_child self
      @gui = Shoes.backend_for(self, &blk)

      clickable_options(styles)
    end
  end
end
