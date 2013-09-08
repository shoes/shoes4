class Shoes
  class InputBox
    include CommonMethods
    include Common::Changeable
    include DimensionsDelegations

    attr_reader :gui, :blk, :parent, :opts, :dimensions

    def initialize(app, parent, text, opts, blk = nil)
      @app = app
      @parent = parent
      @opts = opts
      @blk = blk
      @dimensions = Dimensions.new @opts
      @text = text

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      self.text = text
      self.change &blk if blk
    end

    def focus
      @gui.focus
    end

    def text
      if @gui
        @gui.text
      else
        @text
      end
    end

    def text=(value)
      @text = value
      @gui.text = value
    end
  end
end
