module Shoes
  module Swt
    class Dialog
      SWT = ::Swt::SWT
      ALERT_STYLE   = SWT::OK | SWT::ICON_INFORMATION
      CONFIRM_STYLE = SWT::YES | SWT::NO | SWT::ICON_QUESTION

      def alert(msg = '')
        open_message_box ALERT_STYLE, msg
        nil
      end

      def confirm(msg = '')
        answer_id = open_message_box CONFIRM_STYLE, msg
        confirmed? answer_id
      end

      private
      def open_message_box(style, msg)
        shell = ::Swt::Widgets::Shell.new ::Swt.display
        @message_box = ::Swt::Widgets::MessageBox.new shell, style
        @message_box.message = msg.to_s
        @message_box.open
      end

      def confirmed?(answer_id)
        answer_id == SWT::YES
      end
    end
  end
end