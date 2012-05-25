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

  end
end

module Shoes
  class Button
    include SwtShoes::Button
  end
end
