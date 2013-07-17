require 'shoes/common/common_methods'

class Shoes
  class Radio
    include Shoes::CommonMethods
    attr_reader :gui, :blk, :parent

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
      @gui     = Shoes.configuration.backend_for(self, @parent.gui, blk)
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
