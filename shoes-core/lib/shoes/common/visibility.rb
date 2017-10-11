# frozen_string_literal: true
class Shoes
  module Common
    module Visibility
      # Hides the element, so that it can't be seen. See also #show and #toggle.
      def hide
        style(hidden: true)
        self
      end

      # Root method for determining whether we're visible or not, taking into
      # account our parent chain's visibility.
      def hidden?
        @parent&.hidden? || style[:hidden]
      end

      alias hidden hidden?

      def visible?
        !hidden?
      end

      # Reveals the element, if it is hidden. See also #hide and #toggle.
      def show
        style(hidden: false)
        self
      end

      # Hides an element if it is shown. Or shows the element, if it is hidden.
      # See also #hide and #show.
      def toggle
        style(hidden: !style[:hidden])
        self
      end

      private

      # Backend elements are expected to respond to update_visibility, and use
      # the hidden? or visible? accessors to assess their proper display state.
      #
      # These take into account parent visibility, versus styling which applies
      # only to the element itself.
      def update_visibility
        gui.update_visibility
        self
      end
    end
  end
end
