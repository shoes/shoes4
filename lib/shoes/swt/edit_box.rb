class Shoes
  module Swt
    class EditBox < InputBox
      include Common::Toggle

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
