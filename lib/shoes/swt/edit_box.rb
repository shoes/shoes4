require 'shoes/swt/input_box'

module Shoes
  module Swt
    class EditBox < InputBox

      def initialize(dsl, parent, blk)
        super(dsl, parent, blk,
          ::Swt::SWT::MULTI  |
          ::Swt::SWT::BORDER |
          ::Swt::SWT::WRAP
          )
      end

    end
  end
end


