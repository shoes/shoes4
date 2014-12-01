class Shoes
  module Swt
    class Progress
      include Common::Child
      include Common::Remove
      include Common::Visibility
      include Common::UpdatePosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :parent, :real, :dsl

      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent

        @real = ::Swt::Widgets::ProgressBar.new(@parent.real,
                                                ::Swt::SWT::SMOOTH)
        @real.minimum = 0
        @real.maximum = 100

        if @dsl.element_width && @dsl.element_height
          @real.setSize dsl.element_width, dsl.element_height
        else
          @real.pack
          @dsl.element_width  = @real.size.x
          @dsl.element_height = @real.size.y
        end
      end

      def fraction=(value)
        @real.selection = (value * 100).to_i unless @real.disposed?
      end
    end
  end
end
