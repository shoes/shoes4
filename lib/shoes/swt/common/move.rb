class Shoes
  module Swt
    module Common
      module Move
        def displace(left, top)
          bounds = real.getBounds
          real.setLocation(bounds.x + left, bounds.y + top)
        end
      end
    end
  end
end

