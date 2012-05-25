module Shoes
  class Edit_box < Native
    java_import 'javax.swing.JTextArea'
    java_import 'javax.swing.JScrollPane'
    
    attr_accessor :scrollpane
    
    def initialize(parent, opts={})
      super(opts)
      opts[:width] ||= 40
      opts[:height] ||= 40
      @bottom = opts[:bottom]
      @editbox = JTextArea.new(opts[:height], opts[:width])
      if(opts[:scroll])
        @scrollpane = JScrollPane.new(@editbox, JScrollPane::VERTICAL_SCROLLBAR_ALWAYS, JScrollPane::HORIZONTAL_SCROLLBAR_NEVER)
        parent.add(@scrollpane)
      else
        parent.add(@editbox)
      end
      return @editbox
    end
    
    def to_java
      @editbox.to_java
    end
    
    def append(text)
      if(@bottom)
        @editbox.append(text.to_s)
        position = @editbox.getDocument.getLength()
        if @editbox.modelToView(position)
         @editbox.scrollRectToVisible(java.awt.Rectangle.new(@editbox.modelToView(position)))
        end
      else
        @editbox.append(text.to_s)
      end
      
    end
  end
end