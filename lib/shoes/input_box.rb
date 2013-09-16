class Shoes
  class InputBox
    include CommonMethods
    include Common::Changeable
    include DimensionsDelegations

    attr_reader :gui, :blk, :parent, :dimensions, :initial_text
    attr_accessor :state

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
      self.state = opts[:state] 
    end

    def state=(value)
      @state = value
      @gui.enabled value.nil?
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

  class EditBox < InputBox
    DEFAULT_STYLE = { width: 200,
                      height: 108 }

    def initialize(app, parent, text, opts={}, blk = nil)
      super(app, parent, text, DEFAULT_STYLE.merge(opts), blk)
    end
  end

  class EditLine < InputBox
    DEFAULT_STYLE = { width:  200,
                      height: 28 }

    def initialize(app, parent, text, opts={}, blk = nil)
      super(app, parent, text, DEFAULT_STYLE.merge(opts), blk)
    end
  end

end
