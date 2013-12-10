class Shoes
  module Swt
    module Common
      module Clear
        def clear
          app.remove_paint_listener @painter
          remove_click_listeners
          @real.dispose unless @real && @real.disposed?
        end

        private
        def remove_click_listeners
          app.remove_listener ::Swt::SWT::MouseDown, @click_listener
          app.remove_listener ::Swt::SWT::MouseUp, @click_listener
        end
      end
    end
  end
end
