module WhiteShoes
  class Base
    attr_accessor :adapted_object

    def initialize(adapted_object)
      self.adapted_object = adapted_object
    end
  end
end
