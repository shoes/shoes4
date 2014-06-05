# -*- coding: utf-8 -*-
class Shoes
  # Methods common to Shoes gui elements.
  #
  # Classes that include this module must expose:
  #
  # gui    - the "real" backend implementation of the object
  # parent - the parent element e.g. the containing slot
  module CommonMethods

    # Hides the element, so that it can't be seen. See also #show and #toggle.
    def hide
      @hidden = false
      toggle
    end

    def hidden?
      @hidden
    end

    alias_method :hidden, :hidden?

    def visible?
      !hidden?
    end

    # Reveals the element, if it is hidden. See also #hide and #toggle.
    def show
      @hidden = true
      toggle
    end

    # Hides an element if it is shown. Or shows the element, if it is hidden.
    # See also #hide and #show.
    def toggle
      @hidden = !@hidden
      @gui.toggle
      self
    end

    # Moves an element to a specific pixel position. The element is still in the slot,
    # but will no longer be stacked or flowed with the other stuff in the slot.
    def move(left, top)
      self.left = left
      self.top  = top
      self
    end

    # NOT part of the public interface e.g. no Shoes APP should use this
    # however we need it from the Slot code to position elements
    def _position left, top
      self.absolute_left = left
      self.absolute_top  = top
      @gui.update_position if @gui && @gui.respond_to?(:update_position)
    end

    def remove
      parent.remove_child self if parent
      gui.clear if gui && gui.respond_to?(:clear)
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
