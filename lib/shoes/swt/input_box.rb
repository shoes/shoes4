require 'shoes/color'

module Shoes
  module Swt
    # Class is used by edit_box and edit_line
    class InputBox
      include Common::Child

      attr_reader :real

      def initialize(dsl, parent, blk, text_options)
        @dsl = dsl
        @parent = parent
        @blk = blk
        @text_options = text_options

        @real = ::Swt::Widgets::Text.new(@parent.real, text_options)
        @real.pack
      end

      def text=(value)
        @real.text = value
      end

      def move(left, top)
        unless @real.disposed?
          @real.set_location left, top
        end
      end

      def width
        @real.size.x
      end

      def height
        @real.size.y
      end

    end
  end
end
