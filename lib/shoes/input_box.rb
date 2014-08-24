class Shoes
  class InputBox
    include Common::UIElement
    include Common::Style
    include Common::Changeable

    attr_reader :app, :parent, :dimensions, :gui
    style_with :change, :common_styles, :dimensions, :text, :state

    def initialize(app, parent, text, styles, blk = nil)
      @app = app
      @parent = parent
      style_init styles, text: text
      @dimensions = Dimensions.new parent, @style
      @parent.add_child self
      @gui = Shoes.configuration.backend_for self, @parent.gui
      change &blk if blk
    end

    def state=(value)
      style state: value
      @gui.enabled value.nil?
    end

    def focus
      @gui.focus
    end

    def text
      @gui.text
    end

    def text=(value)
      style text: value.to_s
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
    STYLES = { width: 200, height: 108, text: '' }

    def initialize(app, parent, text, styles = {}, blk = nil)
      super(app, parent, text, styles, blk)
    end
  end

  class EditLine < InputBox

    STYLES = { width:  200, height: 28, text: '' }
    style_with :secret

    def initialize(app, parent, text, styles = {}, blk = nil)
      super(app, parent, text, styles, blk)
    end

    def secret?
      self.secret
    end

  end

end
