class Shoes
  module Common
    module Visibility
      # Hides the element, so that it can't be seen. See also #show and #toggle.
      def hide
        style[:hidden] = true
        update_visibility
      end

      def hidden?
        style[:hidden]
      end

      alias_method :hidden, :hidden?

      def visible?
        !hidden?
      end

      # Reveals the element, if it is hidden. See also #hide and #toggle.
      def show
        style[:hidden] = false
        update_visibility
      end

      # Hides an element if it is shown. Or shows the element, if it is hidden.
      # See also #hide and #show.
      def toggle
        style[:hidden] = !style[:hidden]
        update_visibility
      end

      private

      def update_visibility
        gui.update_visibility if gui.respond_to?(:update_visibility)
        self
      end
    end
  end
end
