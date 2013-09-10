class Shoes
  class Button
    include Shoes::CommonMethods
    include Shoes::Common::Clickable
    include DimensionsDelegations

    attr_reader :parent, :blk, :gui, :opts, :dimensions
    attr_accessor :text, :state

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
      self.state = @opts[:state] 
    end

    def state=(value)
      @state = value
      @gui.enabled value.nil?
    end

    def focus
      @gui.focus
    end
  end
end
