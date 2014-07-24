class Shoes
  class ListBox
    include Common::UIElement
    include Common::Style
    include Common::Changeable

    STYLES = {width: 200, height: 20, items: [""]}

    attr_reader :items, :app, :gui, :blk, :parent, :styles, :dimensions
    style_with :change, :choose, :dimensions, :items, :state, :text

    def initialize(app, parent, styles = {}, blk = nil)
      @app        = app
      @parent     = parent
      style_init(styles)
      @dimensions = Dimensions.new parent, @style

      @gui = Shoes.configuration.backend_for(self, @parent.gui)
      @parent.add_child self

      self.change &blk if blk
      self.items = @style[:items]
      choose(@style[:choose]) if @style.has_key?(:choose)
    end

    def items=(values)
      @items = values
      @gui.update_items values
    end

    def text
      @gui.text
    end

    def choose(item_or_hash)
      case item_or_hash
      when String
        @gui.choose item_or_hash
      when Hash
        @gui.choose item_or_hash[:item]
      end
    end

    def choose=(item)
      choose(item)
    end
    
    def state=(value)
      @style[:state] = value
      @gui.enabled value.nil?
    end
  end
end
