class Shoes
  class ProxyArray < SimpleDelegator
    attr_accessor :gui

    def initialize(array, gui)
      @gui = gui
      super(array)
    end

    def method_missing(method, *args, &block)
      res = super(method, *args, &block)
      gui.update_items

      case res
      when ProxyArray, Array
        self
      else
        res
      end
    end

    def to_a
      __getobj__
    end
  end

  class ListBox
    include Common::UIElement
    include Common::Style
    include Common::Changeable

    style_with :change, :choose, :common_styles, :dimensions, :items, :state, :text
    STYLES = { width: 200, height: 20, items: [""] }

    def handle_block(blk)
      change(&blk) if blk
    end

    def after_initialize
      proxy_array = Shoes::ProxyArray.new(items, @gui)
      @style[:items] = proxy_array
      choose @style[:choose]
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
