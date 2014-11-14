class Shoes
  module Mock
    class Check
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(*_opts)
      end

      def checked?
        false
      end

      def checked=(*_opts)
      end

      def focus
      end

      def enabled(_value)
      end
    end
  end
end
