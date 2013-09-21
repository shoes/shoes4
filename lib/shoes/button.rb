class Shoes
  class Button
    include Shoes::CommonMethods
    include Shoes::Common::Clickable
    include Shoes::Common::State
    include DimensionsDelegations

    attr_reader :parent, :blk, :gui, :opts, :dimensions
    attr_accessor :text

    def initialize(app, parent, text = 'Button', opts = {}, blk = nil)
      @app    = app
      @parent = parent
      @text   = text
      @opts   = opts
      @blk    = blk

      @dimensions = Dimensions.new opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui)

      parent.add_child self

      clickable_options(opts)
      state_options(opts)
    end

    def focus
      @gui.focus
    end
  end
end
