module Shoes
  module Swt
    class ListBox
      include Common::Child
      include Common::Clear

      # Create a list box
      #
      # @param [Shoes::List_obx] dsl The Shoes DSL list box this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent, blk)
        dsl.opts[:width] ||= 200
        dsl.opts[:height] ||= 20
        @dsl = dsl
        @parent = parent
        @blk = blk
        @real = ::Swt::Widgets::Combo.new(@parent.real,
          ::Swt::SWT::DROP_DOWN | ::Swt::SWT::READ_ONLY)
        @real.setSize dsl.opts[:width], dsl.opts[:height]
        @real.addSelectionListener{|e| blk[@dsl]} if blk
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


