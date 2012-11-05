module Shoes
  module Swt
    module Common
      module Clear
        def clear
          @container.redraw(@left, @top, @width, @height, false) unless @container.disposed?
          @container.remove_paint_listener @painter if @painter
        end
      end
    end
  end
end
