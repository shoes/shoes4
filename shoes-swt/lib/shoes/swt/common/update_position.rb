class Shoes
  module Swt
    module Common
      module UpdatePosition
        # Updates the position of this object. This object does not have its
        # own painter, so we need to update the position manually.
        def update_position
          unless @real.disposed?
            @real.set_location dsl.element_left, dsl.element_top

            # Why update size too? On Mac, SWT snaps sizing to defaults after
            # setting location for reasons I've yet to understand. #1323
            @real.set_size dsl.element_width, dsl.element_height
          end
        end
      end
    end
  end
end
