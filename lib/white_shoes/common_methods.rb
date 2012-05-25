module WhiteShoes
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

    # This is the position of the Element from the top
    # of the Slot.  (pixels)
    def top
      bounds.y
    end

    # This is the position of the right side of the Element,
    # measured from the *left* side of the Slot.  (pixels)
    def right
      bounds.x + bounds.width
    end

    # This is the position of the bottom of the Element,
    # measured from the *top* of the Slot.  (pixels)
    def bottom
      bounds.y + bounds.height
    end

    # Gets you the pixel position of the left edge of the element.
    def left
      bounds.x
    end

    # The vertical screen size of the element in pixels.  In the case of images,
    # this is not the full size of the image.  This is the height of the element
    # as it is shown right now.
    #
    # If you have a 150x150 pixel image and you set the width to 50 pixels, this
    # method will return 50.
    #
    # Also see the width method for an example and some other comments.
    def height
      bounds.height
    end

    # This is the width of the Element. (Pixels)
    def width
      bounds.width
    end

    # Hides the element, so that it can't be seen. See also #show and #toggle.
    def hide

    end

    # Reveals the element, if it is hidden. See also #hide and #toggle.
    def show

    end

    # Hides an element if it is shown. Or shows the element, if it is hidden.
    # See also #hide and #show.
    def toggle

    end

    # displace(left: a number, top: a number) » self
    # Displacing an element moves it.  But without changing the layout around it.
    def displace(left, top)
      gui_container.setLocation(bounds.x + left, bounds.y + top)
      #@swt_composite.pack
    end

    private
    def bounds
      gui_container ||= gui_container.getBounds
    end


  end
end
