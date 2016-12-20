class Shoes
  class Button
    include Common::UIElement
    include Common::Clickable
    include Common::Style
    include Common::State

    # We don't actually support release from buttons, but want to use the
    # shared infrastructure for clicking. So just get rid of release post def.
    undef release

    style_with :click, :common_styles, :dimensions, :state, :text

    def before_initialize(styles, text)
      styles[:text] = text || 'Button'
    end

    def focus
      @gui.focus
    end

    def text=(value)
      style(text: value.to_s)
      @gui.text = value.to_s
    end
  end
end
