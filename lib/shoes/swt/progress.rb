require 'shoes/swt/swt_button'

module Shoes
  module Swt
    class Progress
      include Common::Child

      # The Swt parent object
      attr_reader :parent

      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk

        @real = ::Swt::Widgets::ProgressBar.new(@parent.real,
                                                ::Swt::SWT::SMOOTH)
        @real.minimum = 0
        @real.maximum = 100
      end

      def fraction=(value)
        @real.selection = (value*100).to_i
      end
    end
  end
end
