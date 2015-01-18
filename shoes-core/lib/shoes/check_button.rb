class Shoes
  class CheckButton
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    def checked?
      @gui.checked?
    end

    def checked=(value)
      style(checked: value)
      @gui.checked = value
    end

    def focus
      @gui.focus
    end

    def state=(value)
      style(state: value)
      @gui.enabled value.nil?
    end
  end

  class Check < CheckButton
    style_with :checked, :click, :common_styles, :dimensions, :state
  end
end
