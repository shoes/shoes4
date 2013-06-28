class Shoes
  module Swt
    class ListBox
      include Common::Child
      include Common::Clear

      # Create a list box
      #
      # @param dsl    [Shoes::List_obx] The Shoes DSL list box this represents
      # @param parent [::Swt::Widgets::Composite] The parent element of this button
      def initialize(dsl, parent)
        dsl.opts[:width] ||= 200
        dsl.opts[:height] ||= 20
        @dsl = dsl
        @parent = parent
        @real = ::Swt::Widgets::Combo.new(
          @parent.real,
          ::Swt::SWT::DROP_DOWN | ::Swt::SWT::READ_ONLY
        )
        @real.set_size dsl.opts[:width], dsl.opts[:height]
        @real.add_selection_listener do |event|
          @dsl.call_change_listeners
        end
      end

      def update_items(values)
        @real.items = values.map(&:to_s)
      end

      # Returns the current selection or nil if nothing
      # has been selected
      def text
        v=@real.text
        v == "" ? nil : v
      end

      def choose(item)
        @real.text = item
      end
      
      def move(left, top)
        unless @real.disposed?
          @real.set_location left, top
        end
      end

      def width
        @real.size.x
      end

      def height
        @real.size.y
      end
    end
  end
end


