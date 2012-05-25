module Shoes
  class Image < Native
    attr_accessor :image
    
    def initialize(path, parent, opts={})
      super(opts)
      myPicture = javax.imageio.ImageIO.read(java.io.File.new(path));
      @image = javax.swing.JLabel.new(javax.swing.ImageIcon.new( myPicture ))
      parent.add( @image )
    end
    
    def to_java
      @image.to_java
    end
    
  end
end