module Shoes
  module Swt
    class Confirm
      def initialize(dsl = nil, parent = nil, msg)
        shell = ::Swt::Widgets::Shell.new ::Swt.display
        @message_box = ::Swt::Widgets::MessageBox.new shell, ::Swt::SWT::YES | ::Swt::SWT::NO | ::Swt::SWT::ICON_INFORMATION
        @message_box.message = msg.to_s
        @answer_id = @message_box.open
        @answer_id == ::Swt::SWT::YES
      end

      def confirmed?
        @answer_id == ::Swt::SWT::YES
      end
    end
  end
end

