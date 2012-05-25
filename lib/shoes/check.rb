module Shoes
  class Check < Native
    attr_accessor :check
    
    def initialize(parent, opts={}, &blk)
      super(opts)
      @check = javax.swing.JCheckBox.new()
      @check.add_item_listener(&blk) unless blk.nil?
      parent.add(@check)
      return @check
    end
    
    def checked?
      @check.isSelected()  
    end
    
    def checked=(selected)
      @check.setSelected(selected)
    end
    
    def to_java
      @check.to_java
    end
    
  end
end