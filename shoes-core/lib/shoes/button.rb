class Shoes
  class Button
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    style_with :click, :common_styles, :dimensions, :state, :text

    def before_initialize(styles, text)
      styles[:text] = text || 'Button'
    end

    def focus
      @gui.focus
    end

    def state=(value)
      style(state: value)
      @gui.enabled value.nil?
    end
  end
end
