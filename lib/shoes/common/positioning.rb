class Shoes
  module Common
    module Positioning
      # Moves an element to a specific pixel position. The element is still in the slot,
      # but will no longer be stacked or flowed with the other stuff in the slot.
      def move(left, top)
        self.left = left
        self.top  = top
        self
      end

      # NOT part of the public interface e.g. no Shoes APP should use this
      # however we need it from the Slot code to position elements
      def _position(left, top)
        self.absolute_left = left
        self.absolute_top  = top
        gui.update_position if gui && gui.respond_to?(:update_position)
      end

      # displace(left: a number, top: a number) » self
      # Displacing an element moves it.  But without changing the layout around it.
      def displace(left, top)
        self.displace_left = left
        self.displace_top = top
        gui.update_position
        self
      end
    end
  end
end
