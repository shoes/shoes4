class Shoes
  module Mock
    class Button
      include Shoes::Mock::CommonMethods

      def enabled(value)
      end

      def displace(left, top)
      end
    end
  end
end
