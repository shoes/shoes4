require 'shoes/swt/swt_button'

module Shoes
  module Swt
    class Progress
      include Common::Child
      include Common::Clear

      # The Swt parent object
      attr_reader :parent, :real

      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk

        @real = ::Swt::Widgets::ProgressBar.new(@parent.real,
                                                ::Swt::SWT::SMOOTH)
        @real.minimum = 0
        @real.maximum = 100

        @real.pack
      end

      def fraction=(value)
        @real.selection = (value*100).to_i
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
