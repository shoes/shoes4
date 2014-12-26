require 'delegate'
require 'after_do'
class Shoes
  class ProxyArray < SimpleDelegator
    attr_reader :array
    attr_accessor :gui, :old_array
    def initialize(array, gui)
      @array = array
      @old_array = array.clone
      @gui = gui
      __setobj__(array)
    end
  end

  ProxyArray.extend AfterDo

  ProxyArray.before :method_missing do |method, *args, obj|
    puts "before method missing old_array was #{obj.old_array}"
    puts "and array was #{obj.array}"
    obj.old_array = obj.array
  end

  ProxyArray.after :method_missing do |method, *args, obj|
    puts "after method missing old_array is #{obj.old_array}"
    puts "and array is #{obj.array}"
    puts "and they are equal? => #{obj.array == obj.old_array}"
    obj.gui.update_items unless obj.array == obj.old_array
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
