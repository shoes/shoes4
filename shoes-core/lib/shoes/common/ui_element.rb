# frozen_string_literal: true
class Shoes
  module Common
    class UIElement
      include Common::Attachable
      include Common::Initialization
      include Common::Inspect
      include Common::Visibility
      include Common::Positioning
      include Common::Remove
      include DimensionsDelegations
      include Common::Style

      # Nobody rotates by default, but we need to let you check
      def needs_rotate?
        false
      end

      # Expected to be overridden by pulling in Common::Fill or Common::Stroke
      # if element needs to actually notify GUI classes of colors changes.
      def update_fill
      end

      def update_stroke
      end
    end
  end
end
