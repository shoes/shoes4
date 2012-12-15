module Shoes
  module Mock
    class Dialog
      def alert(*args)
        nil
      end

      def confirm(msg = '')
        true
      end

      alias_method :confirm?, :confirm
    end
  end
end