class Shoes
  class Progress
    include Common::Initialization
    include Common::UIElement
    include Common::Style

    attr_reader :app, :parent, :dimensions, :gui

    style_with :common_styles, :dimensions, :fraction
    STYLES = { fraction: 0.0 }

    def create_dimensions()
      @dimensions = Dimensions.new parent, @style
    end

    def after_initialize
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
