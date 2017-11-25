# frozen_string_literal: true

class Shoes
  module Swt
    module Common
      module Visibility
        def update_visibility
          if defined?(@real) && @real.respond_to?(:set_visible)
            # hidden_from_view? handles all visiblity conditions, including
            # being outside a slot. SWT as backend doesn't get that for free
            # because we can't use Composites as they lack transparency...
            visible = !@dsl.hidden_from_view?
            @real.set_visible(visible)
          end
        end
      end
    end
  end
end
