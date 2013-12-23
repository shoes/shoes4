class Shoes
  module Swt
    class WithDisposedProtection < BasicObject
      def initialize(real)
        @real = real
      end

      def ==(other)
        @real == other
      end

      def !=(other)
        @real != other
      end

      def method_missing(method, *args, &block)
        @real.public_send method, *args, &block unless @real.disposed?
      end
    end
  end
end
