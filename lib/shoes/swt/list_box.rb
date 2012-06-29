module Shoes
  module Swt
    class List_box
      include Common::Child

      # Create a list box
      #
      # @param [Shoes::List_obx] dsl The Shoes DSL list box this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk
        @real = ::Swt::Widgets::Combo.new(@parent.real,
          ::Swt::SWT::READ_ONLY)
      end

      def update_items(values)
        @real.items = values
      end

      # Returns the current selection or nil if nothing
      # has been selected
      def text
        v=@real.text
        v == "" ? nil : v
      end
    end
  end
end


