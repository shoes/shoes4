class Shoes
  module Mock
    class Download

      def initialize(*_)
      end

      def eval_block(result, &blk)
        blk.call result
      end

    end
  end
end
