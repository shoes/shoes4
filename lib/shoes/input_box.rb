class Shoes
  class InputBox
    include CommonMethods
    include Common::Changeable
    include Common::State
    include DimensionsDelegations

    attr_reader :app, :gui, :blk, :parent, :dimensions, :initial_text

    def initialize(app, parent, text, opts, blk = nil)
      @app          = app
      @parent       = parent
      @blk          = blk
      @dimensions   = Dimensions.new parent, opts
      @initial_text = text
      @secret       = opts[:secret]

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      self.change &blk if blk
      state_options(opts)
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

    def highlight_text(start_index, final_index)
      @gui.highlight_text(start_index, final_index)
    end

    def caret_to(index)
      @gui.caret_to(index)
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
