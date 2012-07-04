require 'shoes/swt/swt_button'

module Shoes
  module Swt
    class Button < SwtButton
      include Common::Child

      # The Swt parent object
      attr_reader :parent

      # Create a button
      #
      # @param [Shoes::Button] dsl The Shoes DSL button this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent, blk)
        super(dsl, parent, ::Swt::SWT::PUSH, blk)
        @real.set_text @dsl.text
      end

      def move(left, top)
        swt_move(left, top) do |button|
          button.set_text @dsl.text
          button.add_selection_listener(@blk) if @blk
        end
      end
    end
  end
end
