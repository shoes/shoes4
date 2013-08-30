# -*- coding: utf-8 -*-
class Shoes
  # Methods common to Shoes gui elements.
  #
  # Classes that include this module must expose:
  #
  # gui_container - the "real" framework implementation object
  module CommonMethods

    #TODO: make this attr_accessor :identifier ??
    # Needs to be inheritable
    #def identifier
    #  @identifier
    #end

    #TODO: make this attr_accessor :native_widget ??
    # Needs to be inheritable
    #def native_widget
    #  gui_container
    #end

    def initialize(opts={})
      @identifier = opts[:id]
    end

    %w[top left width height].each do |e|
      eval "def #{e}; @gui.#{e} rescue @#{e} end"
      eval "def #{e}=(v); @gui.#{e} = v end"
    end

    # This is the position of the right side of the Element,
    # measured from the *left* side of the Slot.  (pixels)
    def right
      left + width
    end

    # This is the position of the bottom of the Element,
    # measured from the *top* of the Slot.  (pixels)
    def bottom
      top + height
    end

    def in_bounds?(x, y)
      visible? and left <= x and x <= right and top <= y and y <= bottom
    end

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
      unslot
      _position left, top
      self
    end

    def unslot
      @parent.contents.delete self if @parent
      @app.unslotted_elements.push self unless @app.unslotted_elements.include?(self)
    end

    # NOT part of the public interface e.g. no Shoes APP should use this
    # however we need it from the Slot code to position elements
    def _position left, top
      @gui.move(left, top) if @gui
      @left, @top = left, top
    end

    def remove
      @parent.contents.delete self if @parent
      @gui.clear
    end

    # displace(left: a number, top: a number) » self
    # Displacing an element moves it.  But without changing the layout around it.
    def displace(left, top)
      gui_container.setLocation(bounds.x + left, bounds.y + top)
    end

    private
    def bounds
      gui_container ||= gui_container.getBounds
    end
  end
end
