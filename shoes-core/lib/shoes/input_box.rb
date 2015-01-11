class Shoes
  class InputBox
    include Common::UIElement
    include Common::Style
    include Common::Changeable

    def before_initialize(styles, text)
      styles[:text] = text.to_s
    end

    def handle_block(blk)
      change(&blk) if blk
      update_visibility
    end

    def state=(value)
      style(state: value)
      @gui.enabled value.nil?
    end

    def focus
      @gui.focus
    end

    def text
      @gui.text
    end

    def text=(value)
      style(text: value.to_s)
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
    style_with :change, :common_styles, :dimensions, :text, :state
    STYLES = { width: 200, height: 108, text: '' }
  end

  class EditLine < InputBox
    style_with :change, :common_styles, :dimensions, :text, :secret, :state
    STYLES = { width:  200, height: 28, text: '' }

    def secret?
      secret
    end
  end
end
