module Shoes
  module Swt
    module Common
      module Toggle
        def toggle
          @dsl.app.gui.real.redraw @left, @top, @width, @height, false unless @dsl.app.gui.real.isDisposed
        end
      end
    end
  end
end
