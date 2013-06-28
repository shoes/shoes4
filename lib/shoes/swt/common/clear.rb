class Shoes
  module Swt
    module Common
      module Clear
        def clear
          if @painter
            @container.redraw(@left, @top, @width, @height, false) unless @container.disposed?
            @container.remove_paint_listener @painter
            remove_click_listeners if @click_listener
          else
            @real.dispose unless @real.disposed?
          end
        end

        private
        def remove_click_listeners
          @container.remove_listener ::Swt::SWT::MouseDown, @click_listener
          @container.remove_listener ::Swt::SWT::MouseUp, @click_listener
        end
      end
    end
  end
end
