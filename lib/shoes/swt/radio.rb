class Shoes
  module Swt
    # In Swt a radio button is actually just a
    # button, so a lot of these methods are
    # borrowed from button.rb
    class Radio < CheckButton
      # Create a list box
      #
      # @param [Shoes::Radio] dsl The Shoes DSL radio this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent)
        super(dsl, parent, ::Swt::SWT::RADIO)
      end
    end
  end
end


