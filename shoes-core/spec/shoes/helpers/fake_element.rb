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

    # Fake this out instead of using Common::Style to avoid things like touching
    # app level styles, etc. that we don't need for testing purposes
    def style
      @style ||= {}
      @style
    end

    attr_accessor :parent, :gui
  end
end
