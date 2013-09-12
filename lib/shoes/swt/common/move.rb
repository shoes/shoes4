class Shoes
  module Swt
    module Common
      module Move
        def move(x, y)
          unless @container.disposed?
            @container.redraw left, top, width, height, false
            @container.redraw x, y, width, height, false
          end
          self.absolute_left = x
          self.absolute_top  = y
        end
      end
    end
  end
end
