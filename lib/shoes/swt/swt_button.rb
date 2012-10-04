module Shoes
  module Swt
    class SwtButton
      # The Swt parent object
      attr_reader :parent, :real

      def initialize(dsl, parent, type, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk

        @type = type
        @real = ::Swt::Widgets::Button.new(@parent.real, @type)
        @real.addSelectionListener{|e| @blk[@dsl]} if @blk

        yield(@real) if block_given?

        @real.pack
      end

      def width=(value)
        # TODO
      end

      def width
        @real.size.x
      end

      def height=(value)
        # TODO
      end

      def height
        @real.size.y
      end

      def focus
        @real.set_focus
      end

      def move(left, top)
        unless @real.disposed?
          @real.set_location left, top
        end
      end

    end
  end
end
