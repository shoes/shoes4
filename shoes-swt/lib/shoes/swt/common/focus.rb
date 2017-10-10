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

        alias focussed? focused?
        alias focussed focused?
        alias focused focused?
      end
    end
  end
end
