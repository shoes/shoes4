class Shoes
  class Progress
    include CommonMethods
    include DimensionsDelegations

    attr_reader :parent, :blk, :gui, :opts, :dimensions, :fraction

    def initialize(app, parent, opts = {}, blk = nil)
      @app        = app
      @parent     = parent
      @opts       = opts
      @blk        = blk
      @dimensions = Dimensions.new opts.merge(parent: parent)
      @gui        = Shoes.configuration.backend_for(self, @parent.gui)

      @parent.add_child self

      @fraction = 0.0
    end

    def fraction=(value)
      @fraction = value
      @gui.fraction = @fraction
    end
  end
end
