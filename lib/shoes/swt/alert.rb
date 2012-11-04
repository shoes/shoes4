module Shoes
  module Swt
    class Alert
      def initialize(dsl, parent, msg)
        shell = ::Swt::Widgets::Shell.new ::Swt.display
        @message_box = ::Swt::Widgets::MessageBox.new shell, ::Swt::SWT::OK | ::Swt::SWT::ICON_INFORMATION
        @message_box.setMessage msg.to_s
        @message_box.open
      end

      def message
        @message_box.message
      end

    end
  end
end

