class Shoes
  module Swt
    class ListBox
      include Common::Child
      include Common::Clear
      include Common::Toggle
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :dsl

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
        @real.set_size dsl.width, dsl.height
        @real.add_selection_listener do |event|
          @dsl.call_change_listeners
        end
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
      
      def move(left, top)
        @real.set_location left, top unless @real.disposed?
      end

      def enabled(value) 
        @real.enable_widget value
      end
    end
  end
end


