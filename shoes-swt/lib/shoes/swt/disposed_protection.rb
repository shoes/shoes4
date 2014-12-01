class Shoes
  module Swt
    module DisposedProtection
      def real
        return NullObject.new(@real) if @real.disposed?
        @real
      end

      class NullObject < BasicObject
        def initialize(real)
          @real = real
        end

        def respond_to?(method)
          @real.respond_to? method
        end

        def method_missing(_method, *_args)
        end
      end
    end
  end
end
