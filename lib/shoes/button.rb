class Shoes
  class Button
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui
    style_with :click, :common_styles, :dimensions, :state, :text

    def initialize(app, parent, text, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init styles, text: text
      @dimensions = Dimensions.new parent, @style
      @parent.add_child self
      @gui = Shoes.configuration.backend_for self, @parent.gui
      register_click blk
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
