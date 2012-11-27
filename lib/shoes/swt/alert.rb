module Shoes
  module Swt
    class Alert
      def initialize(dsl = nil, parent = nil, msg)
        shell = ::Swt::Widgets::Shell.new ::Swt.display
        @message_box = ::Swt::Widgets::MessageBox.new shell, ::Swt::SWT::OK | ::Swt::SWT::ICON_INFORMATION
        @message_box.message = msg.to_s
        @message_box.open
      end
    end
  end
end

