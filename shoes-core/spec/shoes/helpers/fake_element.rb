class Shoes
  class FakeElement < Dimensions
    include Common::Attachable
    include Common::Inspect
    include Common::Positioning
    include Common::Remove
    include Common::Visibility

    def add_child(_element)
      true
    end

    def adjust_current_position(*_)
    end

    # Fake this out instead of using Common::Style to avoid things like touching
    # app level styles, etc. that we don't need for testing purposes
    def style(styles = {})
      @style ||= {}
      @style.merge!(styles)
      @style
    end

    attr_accessor :parent, :gui
  end
end
