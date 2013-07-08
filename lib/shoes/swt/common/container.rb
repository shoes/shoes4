class Shoes
  module Swt
    module Common
      # Container methods
      module Container
        # Adds a painter to be executed when this object needs to be
        # repainted. Delegates to `@real`
        #
        # @param [Painter] painter The code to be executed on paint
        def add_paint_listener(painter)
          @real.add_paint_listener painter
        end

        # Sets top slot to use for layout. Delegates to `@real`
        #
        # @param [Shoes::Slot] slot The dsl-layer top slot
        def top_slot=(slot)
          @real.get_layout.top_slot ||= slot
        end
      end
    end
  end
end
