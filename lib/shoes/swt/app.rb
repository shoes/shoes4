require 'swt'

#require 'shoes/framework_adapters/swt_shoes/window'

module Shoes
  module Swt

    # Shoes::App.new creates a new Shoes application window!
    # The default window is a [flow]
    #
    module App

      def gui_init
        self.gui_container = container = ::Swt::Widgets::Shell.new(::Swt.display, ::Swt::SWT::CLOSE)
        layout = ::Swt::Layout::RowLayout.new
        container.setLayout(layout)

        opts = self.opts

        container.setSize(self.width, self.height)
        container.setText(self.title)

        container.addListener(::Swt::SWT::Close, main_window_on_close)
      end


      def gui_open
        self.gui_container.open

        ::Swt.event_loop { ::Swt.display.isDisposed }

        Shoes.logger.debug "::Swt.display disposed... exiting Shoes::App.new"
      end

      private
      def main_window_on_close
        lambda {
          Shoes.logger.debug "main_window on_close block begin... disposing ::Swt.display"
          ::Swt.display.dispose
          Shoes.logger.debug "::Swt.display disposed"
        }
      end
    end
  end
end

module Shoes
  class App
    include Shoes::Swt::App
  end
end

