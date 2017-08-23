# frozen_string_literal: true
class Shoes
  class CheckButton < Common::UIElement
    include Common::Clickable
    include Common::Focus
    include Common::State

    def checked?
      @gui.checked?
    end

    def checked=(value)
      style(checked: value)
      @gui.checked = value
    end
  end

  class Check < CheckButton
    style_with :checked, :click, :common_styles, :dimensions, :state
  end
end
