class Shoes
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

      def dialog_chooser(title, folder = false, style = :open)
        style = (style == :save ? ::Swt::SWT::SAVE : ::Swt::SWT::OPEN)
        shell = ::Swt::Widgets::Shell.new Shoes.display
        fd = folder ? ::Swt::Widgets::DirectoryDialog.new(shell, style) : ::Swt::Widgets::FileDialog.new(shell, style)
        fd.setText title
        fd.open
      end

      def ask_color(title)
        shell = ::Swt::Widgets::Shell.new Shoes.display
        cd = ::Swt::Widgets::ColorDialog.new shell
        cd.setText title
        color = cd.open
        color ? ::Shoes::Color.new(color.red, color.green, color.blue, ::Shoes::Color::OPAQUE) : ::Shoes::Color.new(0, 0, 0, ::Shoes::Color::OPAQUE)
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
