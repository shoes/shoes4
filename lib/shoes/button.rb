class Shoes
  class Button
    include Shoes::CommonMethods
    include Shoes::Common::Clickable

    def initialize(app, parent, text = 'Button', opts = {}, blk = nil)
      @app    = app
      @parent = parent
      @text   = text
      @opts   = opts
      @blk    = blk

      @gui = Shoes.configuration.backend_for(self, @parent.gui, blk)

      @gui.height = opts[:height]
      @gui.width  = opts[:width]

      @parent.add_child self

      clickable_options(opts)
    end

    attr_reader :parent
    attr_reader :blk
    attr_reader :gui, :opts
    attr_accessor :text

    def focus
      @gui.focus
    end
  end
end
