class Shoes
  class ImagePattern
    def initialize path
      @path = path
      @gui = Shoes.configuration.backend_for(self, path)
    end
    
    attr_reader :gui, :path
  end
end
