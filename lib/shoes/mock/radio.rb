class Shoes
  module Mock
    class Radio
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
    end
  end
end
