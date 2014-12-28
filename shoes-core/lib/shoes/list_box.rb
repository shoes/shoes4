require 'delegate'
require 'after_do'
class Shoes
  class ProxyArray < SimpleDelegator
    extend AfterDo
    attr_accessor :gui

    ARRAY_MODIFYING_METHODS = [:<<, :add, :delete, :map!, :select!]

    def initialize(array, gui)
      @gui = gui
      super(array)
    end

    def method_missing(method, *args, &block)
      res = super(method, *args, &block)
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

    after :method_missing do |method, *args, obj|
      obj.gui.update_items if ARRAY_MODIFYING_METHODS.include? method
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
      proxy_array = Shoes::ProxyArray.new(items, @gui)
      @style[:items] = proxy_array
      change(&blk) if blk

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
