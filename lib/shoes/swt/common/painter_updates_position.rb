class Shoes
  module Swt
    module Common
      module PainterUpdatesPosition
        # No-op. This object manages its own position with its own painter. The
        # painter is triggered automatically in the event loop.
        def update_position
        end
      end
    end
  end
end
