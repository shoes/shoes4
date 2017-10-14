# frozen_string_literal: true

class Shoes
  class Button < Common::UIElement
    include Common::Clickable
    include Common::Focus
    include Common::State

    # We don't actually support release from buttons, but want to use the
    # shared infrastructure for clicking. So just get rid of release post def.
    undef release

    style_with :click, :common_styles, :dimensions, :state, :text

    def before_initialize(styles, text)
      styles[:text] = text || 'Button'
    end

    def text=(value)
      style(text: value.to_s)
      @gui.text = value.to_s
    end
  end
end
