# frozen_string_literal: true

class Shoes
  module Swt
    class Button < SwtButton
      # Create a button
      #
      # @param [Shoes::Button] dsl The Shoes DSL button this represents
      # @param [Shoes::Swt::App] app The app element of this button
      def initialize(dsl, app)
        super(dsl, app, ::Swt::SWT::PUSH) do |button|
          button.set_text @dsl.text
        end
      end

      def text=(value)
        @real.text = value
      end
    end
  end
end
