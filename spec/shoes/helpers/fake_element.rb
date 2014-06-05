class Shoes
  class FakeElement < Dimensions
    include CommonMethods

    def add_child(element)
      true
    end

    attr_accessor :parent, :gui
  end
end