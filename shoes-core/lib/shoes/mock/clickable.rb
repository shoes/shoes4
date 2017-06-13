# frozen_string_literal: true
class Shoes
  module Mock
    module Clickable
      def click(_blk)
        @mock_clickable_block = _blk
      end

      def release(_blk)
      end
    end
  end
end
