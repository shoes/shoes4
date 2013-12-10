class Shoes
  module Swt
    module Common
      module Clear
        def clear
          @container.remove_paint_listener @painter if @painter
          remove_click_listeners if @click_listener
          @real.dispose unless @real.disposed?
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
