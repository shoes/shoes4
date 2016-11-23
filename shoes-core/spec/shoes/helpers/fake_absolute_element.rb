class Shoes
  class FakeAbsoluteElement
    include Common::Attachable
    include Common::Inspect
    include Common::Positioning
    include Common::Remove
    include Common::Visibility

    include Shoes::DimensionsDelegations

    def initialize
      @dimensions = AbsoluteDimensions.new 0, 0, 100, 100
    end

    def add_child(_element)
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

    attr_accessor :dimensions, :parent, :gui
  end
end
