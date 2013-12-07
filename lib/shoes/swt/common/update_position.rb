class Shoes
  module Swt
    module Common
      module UpdatePosition
        def update_position
          unless @real.disposed?
            @real.set_location dsl.element_left, dsl.element_top
          end
        end
      end
    end
  end
end