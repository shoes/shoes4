class Shoes
  module Swt
    module Common
      module Toggle
        def toggle
          # Ugly, but the drawn shapes have gui's without real's
          if @dsl.respond_to?(:gui) && @dsl.gui && @dsl.gui.respond_to?(:real) && @dsl.gui.real
            @dsl.gui.real.set_visible(@dsl.visible?)
          end

          unless @dsl.app.gui.real.is_disposed?
            @dsl.app.gui.real.redraw dsl.left, dsl.top, dsl.width, dsl.height, false
          end
        end
      end
    end
  end
end
