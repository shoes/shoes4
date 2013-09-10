class Shoes
  class ImagePattern
    def initialize path
      @path = path
      @gui = Shoes.configuration.backend_for(self)
    end
    
    attr_reader :gui, :path
  end
end
