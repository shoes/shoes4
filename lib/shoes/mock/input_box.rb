class Shoes
  module Mock
    class InputBox
      include Shoes::Mock::CommonMethods
      attr_accessor :left, :top

      def enabled(value)
      end

      def highlight_text(start_index, finish_index)
      end

      def caret_to(index)
      end

      def text
        @dsl.style[:text]
      end
    end

    class EditBox < InputBox
    end

    class EditLine < InputBox
    end
  end
end
