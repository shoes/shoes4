module Shoes
  class Edit_line < Native
    java_import 'javax.swing.JTextField'
    java_import 'java.awt.Dimension'
    
    
    def initialize(parent, opts={})
      super(opts)
      opts[:width] ||= 100
      opts[:text] ||= ""
      
      @textfield = JTextField.new(opts[:text])
      @textfield.setPreferredSize(java.awt.Dimension.new(opts[:width], 25))

      parent.add(@textfield)
      return @textfield
    end
    
    def to_java
      @textfield.to_java
    end
    
    def replace(text)
      @textfield.set_text(text)
    end
  end
end