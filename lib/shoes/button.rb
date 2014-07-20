class Shoes
  class Button
    include Common::UIElement
    include Common::Clickable
    include Common::State

    attr_reader :app, :parent, :blk, :gui, :opts, :dimensions
    attr_accessor :text

    def initialize(app, parent, text, opts = {}, blk = nil)
      @app    = app
      @parent = parent
      @text   = text
      @opts   = opts
      @blk    = blk

      @dimensions = Dimensions.new parent, opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui)

      parent.add_child self

      register_click(opts)
      state_options(opts)
    end

    def focus
      @gui.focus
    end
  end
end
