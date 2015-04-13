class Shoes
  module Common
    module UIElement
      include Common::Initialization
      include Common::Inspect
      include Common::Visibility
      include Common::Positioning
      include Common::Remove
      include DimensionsDelegations

      # Expected to be overridden by pulling in Common::Fill or Common::Stroke
      # if element needs to actually notify GUI classes of colors changes.
      def update_fill
      end

      def update_stroke
      end
    end
  end
end
