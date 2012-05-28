module SwtShoes
  module Button

    def gui_button_init
    # Create a button on the specified _shell_
    #def initialize(container, text = 'Button', opts = {}, &blk)
      self.gui_element = button = Swt::Widgets::Button.new(self.gui_container, Swt::SWT::PUSH)
      button.setText(self.text)
      #@native_widget.setBounds(10, 10, 150, 30)

      button.addSelectionListener(self.click_event_lambda) if click_event_lambda
      button.pack
    end

    def move(left, top)
      super(left, top)
      unless gui_element.disposed?
        # If this element is part of a layout, we need to pop it into its own
        # composite layer before moving it, so the rest of of the elements in
        # the layout can reflow.
        if gui_container.get_layout
          old_gui_container = self.gui_container
          self.gui_container = Swt::Widgets::Composite.new(@app.gui_container, Swt::SWT::NO_BACKGROUND)
          self.gui_element.dispose
          self.gui_container.set_layout nil
          self.gui_element = Swt::Widgets::Button.new(gui_container, Swt::SWT::PUSH).tap do |button|
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

module Shoes
  class Button
    include SwtShoes::Button
  end
end
