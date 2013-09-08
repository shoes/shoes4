class Shoes
  module Swt
    module Common
      module Toggle
        def toggle
          unless @dsl.app.gui.real.isDisposed
            @dsl.app.gui.real.redraw dsl.left, dsl.top, dsl.width, dsl.height, false
          end
        end
      end
    end
  end
end
