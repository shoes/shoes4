class Shoes
  module Swt
    class Progress
      include Common::Child
      include Common::Clear
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :parent, :real

      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent

        @real = ::Swt::Widgets::ProgressBar.new(@parent.real,
                                                ::Swt::SWT::SMOOTH)
        @real.minimum = 0
        @real.maximum = 100

        if @dsl.width and @dsl.height
          @real.setSize dsl.width, dsl.height
        else
          @real.pack
          @dsl.width  = @real.size.x
          @dsl.height = @real.size.y
        end
      end

      def fraction=(value)
        @real.selection = (value*100).to_i
      end

      def move(left, top)
        @real.set_location left, top unless @real.disposed?
      end
    end
  end
end
