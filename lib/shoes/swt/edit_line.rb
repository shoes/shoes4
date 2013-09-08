class Shoes
  module Swt
    class EditLine < InputBox
      def initialize(dsl, parent)
        dsl.width ||= 200
        dsl.height ||= 20
        styles = dsl.secret? ? ::Swt::SWT::SINGLE | ::Swt::SWT::BORDER | ::Swt::SWT::PASSWORD : ::Swt::SWT::SINGLE | ::Swt::SWT::BORDER
        super(dsl, parent, styles)
      end
    end
  end
end
