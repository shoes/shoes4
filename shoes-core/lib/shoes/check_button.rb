class Shoes
  class CheckButton
    include Common::UIElement
    include Common::Style
    include Common::Clickable

    attr_reader :app, :parent, :dimensions, :gui

    def initialize(app, parent, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init styles
      @dimensions = Dimensions.new parent, @style
      @parent.add_child self
      @gui = Shoes.configuration.backend_for self, @parent.gui
      register_click blk
    end

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
