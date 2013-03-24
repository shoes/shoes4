require 'shoes/swt/input_box'

module Shoes
  module Swt
    class EditBox < InputBox

      def initialize(dsl, parent)
        dsl.opts[:width] ||= 200
        dsl.opts[:height] ||= 100
        super(dsl, parent,
          ::Swt::SWT::MULTI  |
          ::Swt::SWT::BORDER |
          ::Swt::SWT::WRAP
        )
      end

    end
  end
end
