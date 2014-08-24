class Shoes
  module Swt
    class ListBox
      include Common::Child
      include Common::Remove
      include Common::Toggle
      include Common::UpdatePosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl, :parent

      # Create a list box
      #
      # @param dsl    [Shoes::List_box] The Shoes DSL list box this represents
      # @param parent [::Swt::Widgets::Composite] The parent element of this button
      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent
        @real = ::Swt::Widgets::Combo.new(
          @parent.real,
          ::Swt::SWT::DROP_DOWN | ::Swt::SWT::READ_ONLY
        )
        @real.set_size dsl.element_width, dsl.element_height
        @real.add_selection_listener do |event|
          @dsl.call_change_listeners
        end
        update_items dsl.style[:items]
        choose dsl.style[:choose] if dsl.style[:choose]
      end

      def update_items(values)
        @real.items = values.map(&:to_s)
      end

      def text
        text = @real.text
        text == '' ? nil : text
      end

      def choose(item)
        @real.text = item
      end

      def enabled(value)
        @real.enable_widget value
      end
    end
  end
end
