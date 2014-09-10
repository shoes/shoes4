class Shoes
  class Progress
    include Common::UIElement
    include Common::Style

    attr_reader :app, :parent, :dimensions, :gui
    style_with :common_styles, :dimensions, :fraction
    STYLES = {fraction: 0.0}

    def initialize(app, parent, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init styles
      @dimensions = Dimensions.new parent, @style
      @parent.add_child self
      @gui = Shoes.configuration.backend_for self, @parent.gui
    end

    def fraction=(value)
      style(fraction: value)
      @gui.fraction = value
    end
  end
end
