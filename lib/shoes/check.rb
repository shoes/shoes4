class Shoes
  class Check
    include Shoes::CommonMethods
    include Shoes::Common::Clickable

    attr_reader :parent
    attr_reader :blk
    attr_reader :gui

    def initialize(app, parent, opts = {}, blk = nil)
      @app    = app
      @parent = parent
      @blk    = blk

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)
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
