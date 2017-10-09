# frozen_string_literal: true
class Shoes
  module Common
    module Focus
      def focus
        @gui.focus
      end

      def focused?
        @gui.focused?
      end
    end
  end
end
