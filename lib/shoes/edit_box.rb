class Shoes
  class EditBox
    include CommonMethods
    include Common::Changeable
    include DimensionsDelegations

    attr_reader :gui, :blk, :parent, :text, :opts, :dimensions

    DEFAULT_STYLE = {
      width: 200,
      height: 108
    }

    def initialize(app, parent, text, opts = {}, blk = nil)
      @app = app
      @parent = parent
      @opts = DEFAULT_STYLE.merge(opts)
      @blk = blk
      @dimensions = Dimensions.new opts

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      self.text = text
      self.change &blk if blk
    end

    def focus
      @gui.focus
    end

    def text
      @gui.text
    end

    def text=(value)
      @gui.text = value
    end
  end
end
