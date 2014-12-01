class Shoes
  module Swt
    module Common
      module Visibility
        def update_visibility
          if @real && @real.respond_to?(:set_visible)
            @real.set_visible(@dsl.visible?)
          end
        end
      end
    end
  end
end
