class Shoes
  class CheckButton
    include CommonMethods
    include Common::Clickable
    include Common::State
    include DimensionsDelegations

    attr_reader :parent, :blk, :gui, :dimensions

    def initialize(app, parent, opts = {}, blk = nil)
      @app        = app
      @parent     = parent
      @blk        = blk
      @dimensions = Dimensions.new opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      clickable_options(opts)
      state_options(opts)
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

  class Radio < CheckButton  
    attr_accessor :group

    def initialize(app, parent, group, opts = {}, blk = nil)
      @group = group
      super(app, parent, opts, blk)
    end
  end

end
