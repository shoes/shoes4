class Shoes
  module Common
    module UIElement
      include Common::Initialization
      include Common::Inspect
      include Common::Visibility
      include Common::Positioning
      include Common::Remove
      include Common::Rotate
      include DimensionsDelegations
    end
  end
end
