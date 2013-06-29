require 'shoes/swt/swt_button'

class Shoes
  module Swt
    # In Swt a radio button is actually just a
    # button, so a lot of these methods are
    # borrowed from button.rb
    class Radio < SwtButton
      include Common::Child

      # The Swt parent object
      attr_reader :parent

      # Create a list box
      #
      # @param [Shoes::Radio] dsl The Shoes DSL radio this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent, blk)
        super(dsl, parent, ::Swt::SWT::RADIO, blk)
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


