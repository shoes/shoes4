class Shoes
  class CheckButton
    include CommonMethods
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :parent, :blk, :gui, :dimensions
    attr_accessor :state

    def initialize(app, parent, opts = {}, blk = nil)
      @app        = app
      @parent     = parent
      @blk        = blk
      @dimensions = Dimensions.new opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      clickable_options(opts)
      self.state = opts[:state] 
    end

    def state=(value)
      @state = value
      @gui.enabled value.nil?
    end

    def checked?
      @gui.checked?
    end

    def checked=(value)
      @gui.checked = value
    end

    def focus
      @gui.focus
    end

    def click
      @blk.call
    end
  end

  class Check < CheckButton ; end
  class Radio < CheckButton ; end

end
