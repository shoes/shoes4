class Shoes
  class Radio
    include CommonMethods
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :gui, :blk, :parent, :dimensions

    # TODO according to the manual a Radio can take these options
    # :checked
    # :click
    # :group
    # :state nil|"readonly"|"disabled"
    def initialize(app, parent, opts = {}, blk = nil)
      @app     = app
      @parent  = parent
      @blk     = blk
      @checked = false
      @dimensions = Dimensions.new opts
      @gui     = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      clickable_options(opts)
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
end
