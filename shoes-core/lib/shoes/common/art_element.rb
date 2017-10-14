# frozen_string_literal: true

class Shoes
  module Common
    class ArtElement < UIElement
      include Common::Clickable
      include Common::Fill
      include Common::Rotate
      include Common::Stroke
      include Common::Translate

      def self.inherited(child)
        # Hover's inclusion generates a styling class per child class.
        # We need to include it at inheritance time to get that behavior.
        child.include Common::Hover
      end

      def painted?
        true
      end
    end
  end
end
