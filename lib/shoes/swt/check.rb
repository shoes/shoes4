class Shoes
  module Swt
    class Check < SwtButton
      include Common::Child

      # The swt parent object
      attr_reader :parent

      # Create a check box
      #
      # @param [Shoes::Button] dsl The Shoes DSL check box this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent, blk)
        super(dsl, parent, ::Swt::SWT::CHECK, blk)
      end

      def checked?
        @real.get_selection
      end

      def checked=(bool)
        @real.set_selection bool
      end
    end
  end
end
