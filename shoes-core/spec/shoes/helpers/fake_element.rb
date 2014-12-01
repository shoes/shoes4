class Shoes
  class FakeElement < Dimensions
    include Common::Inspect
    include Common::Visibility
    include Common::Positioning
    include Common::Remove

    def add_child(element)
      true
    end

    def adjust_current_position(*_)
    end

    attr_accessor :parent, :gui
  end
end
