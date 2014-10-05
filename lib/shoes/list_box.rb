class Shoes
  class ListBox
    include Common::UIElement
    include Common::Style
    include Common::Changeable

    attr_reader :app, :parent, :dimensions, :gui
    style_with :change, :choose, :common_styles, :dimensions, :items, :state, :text
    STYLES = {width: 200, height: 20, items: [""]}

    def initialize(app, parent, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init styles
      @dimensions = Dimensions.new parent, @style
      @parent.add_child self
      @gui = Shoes.configuration.backend_for self, @parent.gui
      change &blk if blk

      choose @style[:choose]
    end

    def items=(values)
      style(items: values)
      @gui.update_items
    end

    def text
      @gui.text
    end

    def choose(item_or_hash = nil)
      case item_or_hash
      when String
        style(choose: item_or_hash)
        @gui.choose item_or_hash
      when Hash
        style(choose: item_or_hash[:item])
        @gui.choose item_or_hash[:item]
      end
    end

    alias_method :choose=, :choose

    def state=(value)
      style(state: value)
      @gui.enabled value.nil?
    end
  end
end
