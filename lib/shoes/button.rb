class Shoes
  class Button
    include Common::UIElement
    include Common::Clickable
    include Common::Style

    attr_reader :app, :parent, :dimensions, :gui
    style_with :click, :dimensions, :state, :text

    def initialize(app, parent, text, styles = {}, blk = nil)
      @app    = app
      @parent = parent
      @dimensions = Dimensions.new parent, styles

      style_init(styles, text: text)
      @gui = Shoes.configuration.backend_for(self, @parent.gui)

      @parent.add_child self

      register_click(styles, blk)
    end

    def focus
      @gui.focus
    end
    
    def state=(value)
      @style[:state] = value
      @gui.enabled value.nil?
    end

  end
end
