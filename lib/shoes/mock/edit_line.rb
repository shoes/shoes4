class Shoes
  module Mock
    class EditLine
      include Shoes::Mock::CommonMethods
      attr_accessor :text, :left, :top

      def enabled(value)
      end
    end
  end
end
