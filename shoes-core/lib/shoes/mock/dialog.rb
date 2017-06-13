# frozen_string_literal: true
class Shoes
  module Mock
    class Dialog
      def alert(*_args)
        nil
      end

      def dialog_chooser(*_args)
        'test_file_delete_after'
      end

      def confirm(_msg = '')
        true
      end
    end
  end
end
