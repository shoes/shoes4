# frozen_string_literal: true
class Shoes
  module Common
    module SafelyEvaluate
      def safely_evaluate(*args)
        yield(*args) if block_given?
      rescue => e
        Shoes.logger.error(e.message)
        raise e if Shoes.configuration.fail_fast
      end
    end
  end
end
