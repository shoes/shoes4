# frozen_string_literal: true

class Shoes
  module Swt
    module Common
      module Focus
        def focus
          @real.set_focus
        end

        def focused?
          @real.has_focus
        end
      end
    end
  end
end
