# frozen_string_literal: true

class Shoes
  module Swt
    class Check < CheckButton
      # Create a check box
      #
      # @param [Shoes::Button] dsl The Shoes DSL check box this represents
      # @param [Shoes::Swt::App] parent The parent element of this button
      def initialize(dsl, parent)
        super(dsl, parent, ::Swt::SWT::CHECK)
      end
    end
  end
end
