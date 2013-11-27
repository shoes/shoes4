class Shoes
  module Swt
    module Common
      module Toggle
        def toggle
          if @real && @real.respond_to?(:set_visible)
            @real.set_visible(@dsl.visible?)
          end

          unless @dsl.app.gui.real.is_disposed?
            @dsl.app.gui.real.redraw dsl.element_left, dsl.element_top,
                                     dsl.element_width, dsl.element_height, false
          end
        end
      end
    end
  end
end
