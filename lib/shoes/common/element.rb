class Shoes
  module Common
    module Element
      include Common::Inspect
      include Common::Visibility
      include Common::Positioning
      include Common::Remove
      include DimensionsDelegations
    end
  end
end
