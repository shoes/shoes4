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
        @parent_real = @parent.real
      end

      # The Shoes::Swt parent object
      attr_reader :parent

      # The Swt parent object
      attr_reader :parent_real

      def focus
        @real.set_focus
      end

      def move(left, top)
        unless @real.disposed?
          # If this element is part of a layout, we need to pop it into its own
          # composite layer before moving it, so the rest of of the elements in
          # the layout can reflow.
          if @parent_real.get_layout
            old_parent_real = @parent_real
            app_real = app.real
            new_parent_real = ::Swt::Widgets::Composite.new(app_real, ::Swt::SWT::NONE)
            new_parent_real.set_bounds @real.bounds
            new_parent_real.set_location left, top
            new_parent_real.layout = nil
            @real.dispose
            @real = ::Swt::Widgets::Button.new(new_parent_real, ::Swt::SWT::PUSH).tap do |button|
              button.text = @dsl.text
              button.add_selection_listener(@blk) if @blk
              button.pack
            end
            new_parent_real.move_above(old_parent_real)
            # This is the Swt parent. In the DSL, the parent hasn't changed.
            @parent_real = new_parent_real
            old_parent_real.layout
            old_parent_real.pack
            @real.set_location 0, 0
            @real.redraw
          else
            @parent_real.set_location left, top
            @parent_real.redraw
          end
        end
      end
    end
  end
end
