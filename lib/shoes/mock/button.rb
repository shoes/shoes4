class Shoes
  module Mock
    class Button
      include Shoes::Mock::CommonMethods

      def enabled(value)
      end
    end
  end
end
