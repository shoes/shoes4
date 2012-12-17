module Shoes
  module Mock
    class Dialog
      def alert(*args)
        nil
      end

      def confirm(msg = '')
        true
      end
    end
  end
end