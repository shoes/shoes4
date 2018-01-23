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

      # Redrawing needs a bit of extra room. We offset by this factor, then
      # extend our size by twice that to evenly surround the whole thing.
      REDRAW_OFFSET_FACTOR = 1
      REDRAW_SIZING_FACTOR = REDRAW_OFFSET_FACTOR * 2

      def redraw_left
        return 0 unless element_left
        element_left - strokewidth.ceil * REDRAW_OFFSET_FACTOR
      end

      def redraw_top
        return 0 unless element_top
        element_top - strokewidth.ceil * REDRAW_OFFSET_FACTOR
      end

      def redraw_width
        return 0 unless element_width
        element_width + strokewidth.ceil * REDRAW_SIZING_FACTOR
      end

      def redraw_height
        return 0 unless element_height
        element_height + strokewidth.ceil * REDRAW_SIZING_FACTOR
      end
    end
  end
end
