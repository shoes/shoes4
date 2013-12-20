class Shoes
  class ListBox
    include CommonMethods
    include Common::Changeable
    include Common::State
    include DimensionsDelegations

    DEFAULT_WIDTH = 200
    DEFAULT_HEIGHT = 20

    attr_reader :items, :app, :gui, :blk, :parent, :opts, :dimensions

    def initialize(app, parent, opts = {}, blk = nil)
      @app        = app
      @parent     = parent
      @blk        = blk
      @opts       = opts
      @dimensions = Dimensions.new parent, opts
      @dimensions.width  ||= DEFAULT_WIDTH
      @dimensions.height ||= DEFAULT_HEIGHT

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      self.items = opts.has_key?(:items) ? opts[:items] : [""]
      choose(opts[:choose]) if opts.has_key?(:choose)
      @parent.add_child self

      self.change &blk if blk
      state_options(opts)
    end

    def items=(values)
      @items = values
      @gui.update_items values
    end

    def text
      @gui.text
    end

    def choose(item)
      @gui.choose item
    end
  end
end
