class Shoes
  module Common
    module Visibility
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
        gui.toggle
        self
      end
    end
  end
end
