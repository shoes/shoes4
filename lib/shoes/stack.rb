module Shoes
class Stack < Native
  java_import "javax.swing.JPanel"
  java_import "javax.swing.BoxLayout"
  java_import "java.awt.Dimension"
  
  attr_accessor :panel
  def initialize(opts={})
    super(opts)
    @panel = JPanel.new()
    layout = BoxLayout.new(@panel, BoxLayout::PAGE_AXIS)
    @panel.set_layout(layout)
    if(opts[:width] && opts[:height])
      @panel.set_preferred_size(java.awt.Dimension.new(opts[:width], opts[:height]))
    end
  end
  
end
end