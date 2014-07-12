class Shoes
  class FakeElement < Dimensions
    include CommonMethods

    def add_child(element)
      true
    end

    def adjust_current_position(*_)
    end

    attr_accessor :parent, :gui
  end
end
