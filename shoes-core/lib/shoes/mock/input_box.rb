class Shoes
  module Mock
    class InputBox
      include Shoes::Mock::CommonMethods
      attr_accessor :left, :top

      def enabled(_value)
      end

      def highlight_text(_start_index, _finish_index)
      end

      def caret_to(_index)
      end

      def text
        @dsl.style[:text]
      end

      def text=(_value)
      end
    end

    class EditBox < InputBox
    end

    class EditLine < InputBox
    end
  end
end
