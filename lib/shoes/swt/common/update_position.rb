class Shoes
  module Swt
    module Common
      module UpdatePosition
        # Updates the position of this object. This object does not have its
        # own painter, so we need to update the position manually.
        def update_position
          unless @real.disposed?
            @real.set_location dsl.element_left, dsl.element_top
          end
        end
      end
    end
  end
end
