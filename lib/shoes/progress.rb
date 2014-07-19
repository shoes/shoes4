class Shoes
  class Progress
    include Common::Element

    attr_reader :app, :parent, :blk, :gui, :opts, :dimensions, :fraction

    def initialize(app, parent, opts = {}, blk = nil)
      @app        = app
      @parent     = parent
      @opts       = opts
      @blk        = blk
      @dimensions = Dimensions.new parent, opts
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
