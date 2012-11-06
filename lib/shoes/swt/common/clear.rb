module Shoes
  module Swt
    module Common
      module Clear
        def clear
          if @painter
            @container.redraw(@left, @top, @width, @height, false) unless @container.disposed?
            @container.remove_paint_listener @painter
            @container.remove_listener ::Swt::SWT::MouseDown, @ln if @ln
            @container.remove_listener ::Swt::SWT::MouseUp, @ln if @ln
          else
            @real.dispose unless @real.disposed?
          end
        end
      end
    end
  end
end
