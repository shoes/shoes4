class Shoes
  class CheckButton
    include Common::UIElement
    include Common::Clickable
    include Common::Style

    attr_reader :app, :parent, :dimensions, :gui
    style_with :checked, :click, :dimensions, :state

    def initialize(app, parent, styles = {}, blk = nil)
      @app        = app
      @parent     = parent
      @dimensions = Dimensions.new parent, styles

      style_init(styles)
      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      register_click(styles, blk)
    end

    def checked?
      @gui.checked?
    end

    def checked=(value)
      @gui.checked = value
    end

    def focus
      @gui.focus
    end

    def state=(value)
      @style[:state] = value
      @gui.enabled value.nil?
    end

  end

  class Check < CheckButton ; end


end
