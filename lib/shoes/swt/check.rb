module Shoes
  module Swt
    class Check
      include Common::Child

      # The Swt parent object
      attr_reader :parent

      # Create a check box
      #
      # @param [Shoes::Button] dsl The Shoes DSL check box this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk
        @real = ::Swt::Widgets::Button.new(@parent.real,
                                ::Swt::SWT::RADIO).tap do |button|
          button.addSelectionListener(@blk) if @blk
          button.pack
        end
      end

      def checked?
        @real.get_selection
      end

      def checked=(bool)
        @real.set_selection bool
      end

      def focus
        @real.set_focus
      end

      def move(left, top)
        unless @real.disposed?
          # If this element is part of a layout, we need to pop it into its own
          # composite layer before moving it, so the rest of of the elements in
          # the layout can reflow.
          if @parent.real.get_layout
            old_parent_real = @parent.real
            app_real = app.real
            new_composite = ::Swt::Widgets::Composite.new(app_real, ::Swt::SWT::NO_BACKGROUND)
            @real.dispose
            new_composite.set_layout nil
            @real = ::Swt::Widgets::Button.new(new_composite,
                        ::Swt::SWT::CHECK).tap do |button|
              button.pack
            end
            new_composite.set_bounds(0, 0, app_real.size.x, app_real.size.y)
            new_composite.move_above(old_parent_real)
            old_parent_real.layout
          end
          @real.set_location left, top
          @real.redraw
        end
      end
    end
  end
end
