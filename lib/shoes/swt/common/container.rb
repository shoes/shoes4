module Shoes
  module Swt
    module Common
      # Container methods
      module Container
        # Adds a painter to be executed when this object needs to be
        # repainted. Delegates to `@real`
        #
        # @param [Painter] block The code to be executed on paint
        def add_paint_listener(painter)
          @real.add_paint_listener painter
        end
      end
    end
  end
end
