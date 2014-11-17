class Shoes
  module Mock
    class Button
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable
      def enabled(_value)
      end
    end
  end
end
