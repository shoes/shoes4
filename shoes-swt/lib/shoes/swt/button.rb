class Shoes
  module Swt
    class Button < SwtButton
      # Create a button
      #
      # @param [Shoes::Button] dsl The Shoes DSL button this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, app)
        super(dsl, app, ::Swt::SWT::PUSH) do |button|
          button.set_text @dsl.text
        end
      end

      def text=(value)
        @last_text = @real.text
        @real.text = value
      end
    end
  end
end
