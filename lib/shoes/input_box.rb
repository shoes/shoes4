class Shoes
  class InputBox
    include CommonMethods
    include Common::Changeable
    include DimensionsDelegations

    attr_reader :gui, :blk, :parent, :dimensions, :initial_text

    def initialize(app, parent, text, opts, blk = nil)
      @app          = app
      @parent       = parent
      @blk          = blk
      @dimensions   = Dimensions.new opts
      @initial_text = text
      @secret       = opts[:secret]

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      self.change &blk if blk
    end

    def secret?
      @secret
    end

    def focus
      @gui.focus
    end

    def text
      @gui.text
    end

    def text=(value)
      @gui.text = value.to_s
    end
  end
end
