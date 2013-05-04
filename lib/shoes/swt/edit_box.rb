require 'shoes/swt/input_box'

module Shoes
  module Swt
    class EditBox < InputBox

      def initialize(dsl, parent)
        super(dsl, parent,
          ::Swt::SWT::MULTI  |
          ::Swt::SWT::BORDER |
          ::Swt::SWT::WRAP
        )
      end

    end
  end
end
