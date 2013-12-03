class Shoes
  module Swt
    module Common
      module Toggle
        def toggle
          if @real && @real.respond_to?(:set_visible)
            @real.set_visible(@dsl.visible?)
          end

          unless app.disposed?
            app.redraw dsl.element_left, dsl.element_top,
                       dsl.element_width, dsl.element_height, false
          end
        end
      end
    end
  end
end
