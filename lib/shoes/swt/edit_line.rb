require 'shoes/swt/input_box'

module Shoes
  module Swt
    class EditLine < InputBox
      def initialize(dsl, parent, blk)
        dsl.opts[:width] ||= 200
        dsl.opts[:height] ||= 20
        super(dsl, parent, blk,
          ::Swt::SWT::SINGLE |
          ::Swt::SWT::BORDER
          )
      end
    end
  end
end


