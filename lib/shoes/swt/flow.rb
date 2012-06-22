module Shoes
  module Swt
  # flow takes these options
  #   :margin - integer - add this many pixels to all 4 sides of the layout

    # An Swt backend for Shoes::Flow
    class Flow
      include Common::Container
      include Common::Child

      # @param [Shoes::Flow] dsl The Shoes::Flow to provide gui for
      # @param [Swt::Widgets::Composite] parent The parent gui element
      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent
        @real = ::Swt::Widgets::Composite.new(@parent.real, ::Swt::SWT::NO_BACKGROUND).tap do |composite|
          # RowLayout is horizontal by default, wrapping by default
          layout = ::Swt::Layout::RowLayout.new

          # set the margins
          set_margin(layout)

          if @dsl.width && @dsl.height
            composite.setSize(@dsl.width, @dsl.height)
          end

          composite.setLayout(layout)
        end
      end

      attr_reader :real
      attr_reader :parent

      # Add this many pixels to margins on layout
      def set_margin(layout)
        if margin_pixels = @dsl.margin
          layout.marginTop = margin_pixels
          layout.marginRight = margin_pixels
          layout.marginBottom = margin_pixels
          layout.marginLeft = margin_pixels
        end
      end
    end
  end
end
