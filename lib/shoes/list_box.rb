class Shoes
  class ListBox
    include CommonMethods
    include Common::Changeable
    include DimensionsDelegations

    DEFAULT_WIDTH = 200
    DEFAULT_HEIGHT = 20

    attr_reader :items, :gui, :blk, :parent, :opts, :dimensions
    attr_accessor :state

    def initialize(app, parent, opts = {}, blk = nil)
      @app        = app
      @parent     = parent
      @blk        = blk
      @opts       = opts
      @dimensions = Dimensions.new opts
      @dimensions.width  ||= DEFAULT_WIDTH
      @dimensions.height ||= DEFAULT_HEIGHT

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      self.items = opts.has_key?(:items) ? opts[:items] : [""]
      @parent.add_child self

      self.change &blk if blk
      self.state = @opts[:state] 
    end

    def state=(value)
      @state = value
      @gui.enabled value.nil?
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
