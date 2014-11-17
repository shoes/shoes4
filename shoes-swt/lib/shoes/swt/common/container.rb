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

        def remove_paint_listener(painter)
          @real.remove_paint_listener painter if painter
        end

        def add_listener(event, listener)
          @real.add_listener event, listener
        end

        def remove_listener(event, listener)
          @real.remove_listener event, listener if listener
        end
      end
    end
  end
end
