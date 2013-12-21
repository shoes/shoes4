class Shoes
  module Mock
    class InputBox
      include Shoes::Mock::CommonMethods
      attr_accessor :text, :left, :top

      def enabled(value)
      end
    end

    class EditBox < InputBox
    end

    class EditLine < InputBox
    end
  end
end
