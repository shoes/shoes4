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
            puts "@parent.real.layout"
            old_parent_real = @parent_real
            app_real = app.real
            new_parent_real = ::Swt::Widgets::Shell.new(app_real, ::Swt::SWT::NO_TRIM)
# new_parent_real = ::Swt::Widgets::Composite.new(app_real, ::Swt::SWT::NO_BACKGROUND)
            
#            new_parent_real.set_region(@real.region)
            new_parent_real.set_bounds(@real.bounds)
            app_location = app_real.location          
            new_parent_real.set_location(app_location.x + left, app_location.y + top)
            new_parent_real.layout = nil
            @real.dispose
            @real = ::Swt::Widgets::Button.new(new_parent_real, ::Swt::SWT::PUSH).tap do |button|
              button.text = @dsl.text
              button.add_selection_listener(@blk) if @blk
              button.pack
            end
            # new_parent_real.set_bounds(0, 0, app_real.size.x, app_real.size.y)
            new_parent_real.move_above(old_parent_real)
            # This is the Swt parent. In the DSL, the parent hasn't changed.
            @parent_real = new_parent_real
            old_parent_real.layout
            old_parent_real.pack
# old_parent_real.redraw
# @real.set_location left, top
            @real.set_location 0, 0 
            @real.redraw
            @parent_real.open
          else
            absolute_x = app.real.location.x + left
            absolute_y = app.real.location.y + top
            @parent_real.set_location absolute_x, absolute_y 
            @parent_real.redraw
          end
        end
      end
    end
  end
end
