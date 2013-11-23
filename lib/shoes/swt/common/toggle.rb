class Shoes
  module Swt
    module Common
      module Toggle
        def toggle
          if @real && @real.respond_to?(:set_visible)
            @real.set_visible(@dsl.visible?)
          end

          unless @dsl.app.gui.real.is_disposed?
            @dsl.app.gui.real.redraw dsl.left, dsl.top, dsl.width, dsl.height, false
          end
        end
      end
    end
  end
end
