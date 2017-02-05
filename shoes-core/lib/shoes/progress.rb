# frozen_string_literal: true
class Shoes
  class Progress
    include Common::UIElement

    style_with :common_styles, :dimensions, :fraction
    STYLES = { fraction: 0.0 }.freeze

    def after_initialize(*_)
      @gui.fraction = @style[:fraction]
      update_visibility
    end

    def handle_block(*_)
      # No-op since we're not clickable
    end

    def fraction=(value)
      style(fraction: value)
      @gui.fraction = value
    end
  end
end
