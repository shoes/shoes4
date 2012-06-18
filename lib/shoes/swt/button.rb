module Shoes
  module Swt
    class Button
      include Common::Child

      # Create a button
      #
      # @param [Shoes::Button] dsl The Shoes DSL button this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk
        @real = ::Swt::Widgets::Button.new(@parent.real, ::Swt::SWT::PUSH).tap do |button|
          button.setText(@dsl.text)
          button.addSelectionListener(@blk) if @blk
          button.pack
        end
      end

      # The Swt parent object
      attr_reader :parent

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
            @real = ::Swt::Widgets::Button.new(new_composite, ::Swt::SWT::PUSH).tap do |button|
              button.set_text(@dsl.text)
              button.add_selection_listener(@blk) if @blk
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
