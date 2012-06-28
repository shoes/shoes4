module Shoes
  module Swt
    module Common
      # Container methods
      module Container
        # Adds a block of code to be executed when this object needs to be
        # repainted. Delegates to `@real`
        #
        # @param [Proc] block The code to be executed on paint
        def add_paint_listener(block)
          @real.add_paint_listener block
        end
      end
    end
  end
end
