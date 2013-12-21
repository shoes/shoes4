class Shoes
  class Oval
    include CommonMethods
    include Common::Fill
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :dimensions, :angle, :gui

    def initialize(app, parent, left, top, width, height, opts = {}, &blk)
      @app = app
      @dimensions = AbsoluteDimensions.new left, top, width, height, opts
      @style = Shoes::Common::Fill::DEFAULTS.merge(Shoes::Common::Stroke::DEFAULTS).merge(opts)
      @style[:strokewidth] ||= 1
      @angle = opts[:angle]

      parent.add_child self

      @gui = Shoes.backend_for(self, &blk)

      clickable_options(opts)
    end
  end
end
