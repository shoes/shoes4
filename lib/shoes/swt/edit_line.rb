class Shoes
  module Swt
    class EditLine < InputBox

      DEFAULT_STYLES = ::Swt::SWT::SINGLE | ::Swt::SWT::BORDER

      def initialize(dsl, parent)
        styles = DEFAULT_STYLES
        styles |= ::Swt::SWT::PASSWORD if dsl.secret?
        super(dsl, parent, styles)
      end
    end
  end
end
