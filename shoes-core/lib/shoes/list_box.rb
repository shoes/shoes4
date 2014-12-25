class Shoes
  class ProxyArray < BasicObject
    attr_writer :gui
    attr_reader :array

    def initialize(array, gui)
      @array = array
      @gui = gui
    end

    def to_a
      @array
    end

    private

    def method_missing(method, *args, &block)
      @array.send(method, *args, &block)
      @gui.update_items
    end
  end

  class ListBox
    include Common::UIElement
    include Common::Style
    include Common::Changeable

    attr_reader :app, :parent, :dimensions, :gui
    style_with :change, :choose, :common_styles, :dimensions, :items, :state, :text
    STYLES = { width: 200, height: 20, items: [""] }

    def initialize(app, parent, styles = {}, blk = nil)
      @app = app
      @parent = parent
      style_init styles
      @dimensions = Dimensions.new parent, @style
      @parent.add_child self
      @gui = Shoes.configuration.backend_for self, @parent.gui

      @style[:items] = Shoes::ProxyArray.new(items, @gui)
      change(&blk) if blk

      choose @style[:choose]
      @style[:items].gui = @gui
    end

    def items
      @style[:items].to_a
    end

    def items=(vanilla_array)
      proxy_array = Shoes::ProxyArray.new(vanilla_array, @gui)
      style(items: proxy_array)
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
