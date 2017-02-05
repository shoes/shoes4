# frozen_string_literal: true
class Shoes
  module Common
    module UIElement
      include Common::Attachable
      include Common::Initialization
      include Common::Inspect
      include Common::Visibility
      include Common::Positioning
      include Common::Remove
      include DimensionsDelegations

      # Modules that muck with class methods need to be included like this
      def self.included(base)
        base.include Common::Style
      end

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
