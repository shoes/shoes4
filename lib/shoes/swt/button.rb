module Shoes
  module Swt
    class Button

      # Create a button
      #
      # @param [Shoes::Button] dsl The Shoes DSL button this represents
      # @param [::Swt::Widgets::Composite] parent The parent element of this button
      # @param [Proc] blk The block of code to call when this button is activated
      def initialize(dsl, parent, blk)
        @dsl = dsl
        @parent = parent
        @blk = blk
        @real ::Swt::Widgets::Button.new(@parent, ::Swt::SWT::PUSH).tap do |button|
          button.setText(@dsl.text)
          button.addSelectionListener(@blk) if @blk
          button.pack
        end
      end

      def focus
        @real.set_focus
      end

      def move(left, top)
        super(left, top)
        unless gui_element.disposed?
          # If this element is part of a layout, we need to pop it into its own
          # composite layer before moving it, so the rest of of the elements in
          # the layout can reflow.
          if gui_container.get_layout
            old_gui_container = self.gui_container
            self.gui_container = ::Swt::Widgets::Composite.new(@app.gui_container, ::Swt::SWT::NO_BACKGROUND)
            self.gui_element.dispose
            self.gui_container.set_layout nil
            self.gui_element = ::Swt::Widgets::Button.new(gui_container, ::Swt::SWT::PUSH).tap do |button|
              button.set_text(self.text)
              button.add_selection_listener(self.click_event_lambda) if click_event_lambda
              button.pack
            end
            self.gui_container.set_bounds(0, 0, @app.gui_container.size.x, @app.gui_container.size.y)
            self.gui_container.move_above(old_gui_container)
            old_gui_container.layout
          end
          self.gui_element.set_location left, top
          self.gui_element.redraw
        end
      end
    end
  end
end
