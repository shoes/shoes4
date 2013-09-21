class Shoes
  module Mock
    class Check
      include Shoes::Mock::CommonMethods

      def initialize(*opts)
      end

      def checked?
        false
      end

      def checked=(*opts)
      end

      def focus
      end

      def enabled(value)
      end
      
    end
  end
end
