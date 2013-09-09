class Shoes
  module Swt
    class Check < CheckButton
      # Create a check box
      #
      # @param [Shoes::Button] dsl The Shoes DSL check box this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent)
        super(dsl, parent, ::Swt::SWT::CHECK)
      end
    end
  end
end
