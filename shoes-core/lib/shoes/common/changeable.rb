class Shoes
  module Common
    # Changeable elements are elements that receive `change' events.
    # These are ListBox, EditBox and EditLine. To have your code respond
    # to these events, either pass a block in when creating the element,
    # or call #change on the element with a block.
    module Changeable
      # Add an extra change event listener block
      #
      # @yield The block to execute on a change event
      def change(&blk)
        add_change_listener(blk)
      end

      # The GUI backend needs to call this when an actual change happens in
      # the backend.
      def call_change_listeners
        change_listeners.each do |listener|
          listener.call(self)
        end
      end

      private

      def change_listeners
        @change_listeners ||= []
      end

      def add_change_listener(callable)
        change_listeners << callable
      end
    end
  end
end
