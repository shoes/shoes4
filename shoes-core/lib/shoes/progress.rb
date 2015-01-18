class Shoes
  class Progress
    include Common::UIElement
    include Common::Style

    attr_reader :app, :parent, :dimensions, :gui

    style_with :common_styles, :dimensions, :fraction
    STYLES = { fraction: 0.0 }

    def after_initialize(*_)
      @gui.fraction = @style[:fraction]
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
