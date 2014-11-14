class Shoes
  module Swt
    class SwtButton
      include Common::Remove
      include Common::Visibility
      include Common::UpdatePosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :parent, :real, :dsl

      def initialize(dsl, parent, type)
        @dsl = dsl
        @parent = parent

        @type = type
        @real = ::Swt::Widgets::Button.new(@parent.real, @type)

        yield(@real) if block_given?

        set_size
      end

      def eval_block(blk)
        blk.call @dsl
      end

      def focus
        @real.set_focus
      end

      def click(blk)
        remove_listeners
        @real.addSelectionListener { eval_block blk }
      end

      def remove_listeners
        listener_array = @real.getListeners ::Swt::SWT::Selection
        listener_array.each do |listener|
          @real.removeListener ::Swt::SWT::Selection, listener
        end
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
