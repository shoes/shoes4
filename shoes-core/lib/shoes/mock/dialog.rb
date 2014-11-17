class Shoes
  module Mock
    class Dialog
      def alert(*_args)
        nil
      end

      def confirm(_msg = '')
        true
      end
    end
  end
end
