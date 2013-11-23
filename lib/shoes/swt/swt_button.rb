class Shoes
  module Swt
    class SwtButton
      include Common::Clear
      include Common::Toggle
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :parent, :real, :dsl

      def initialize(dsl, parent, type)
        @dsl = dsl
        @parent = parent

        @type = type
        @real = ::Swt::Widgets::Button.new(@parent.real, @type)
        @real.addSelectionListener{|e| eval_block} if @dsl.blk

        yield(@real) if block_given?

        set_size
      end


      def eval_block
        @dsl.blk.call @dsl
      end

      def focus
        @real.set_focus
      end

      def move(left, top)
        @real.set_location left, top unless @real.disposed?
      end

      def click &blk
        @real.addSelectionListener{ blk[self] }
      end

      def enabled(value)
        @real.enable_widget value
      end

      private
      def set_size
        @real.pack
        @dsl.element_width ||= @real.size.x
        @dsl.element_height ||= @real.size.y
        @real.setSize @dsl.element_width, @dsl.element_height
      end
    end
  end
end
