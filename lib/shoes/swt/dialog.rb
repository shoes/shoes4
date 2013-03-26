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

      def dialog_chooser title, folder=false
        style = ::Swt::SWT::OPEN
        shell = ::Swt::Widgets::Shell.new Shoes.display
        fd = folder ? ::Swt::Widgets::DirectoryDialog.new(shell, style) : ::Swt::Widgets::FileDialog.new(shell, style)
        fd.setText title
        fd.open
      end

      def ask msg, args
        Swt::AskDialog.new(::Swt::Widgets::Shell.new, msg, args).open
      end

      def ask_color title
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

    class AskDialog < ::Swt::Widgets::Dialog
      def initialize shell, msg, args
        @shell, @msg, @args= shell, msg, args
        super shell
      end

      def open
        display = getParent.getDisplay
        icon = ::Swt::Graphics::Image.new display, File.join(::Shoes::DIR, 'static/shoes-icon.png')
        @shell.setImage icon
        @shell.setSize 300, 125
        @shell.setText 'Shoes 4 asks:'
        label = ::Swt::Widgets::Label.new @shell, ::Swt::SWT::NONE
        label.setText @msg
        label.setLocation 10, 10
        label.pack
        styles = @args[:secret] ? ::Swt::SWT::BORDER | ::Swt::SWT::SINGLE | ::Swt::SWT::PASSWORD : ::Swt::SWT::BORDER | ::Swt::SWT::SINGLE
        text = ::Swt::Widgets::Text.new @shell, styles
        text.setLocation 10, 30
        text.setSize 270, 20
        b = ::Swt::Widgets::Button.new @shell, ::Swt::SWT::NULL
        b.setText 'OK'
        b.setLocation 180, 55
        b.pack
        b.addSelectionListener{|e| @ret = text.getText; @shell.close}
        b = ::Swt::Widgets::Button.new @shell, ::Swt::SWT::NULL
        b.setText 'CANCEL'
        b.setLocation 222, 55
        b.pack
        b.addSelectionListener{|e| @ret = nil; @shell.close}
        @shell.open
        while !@shell.isDisposed do
          display.sleep unless display.readAndDispatch
        end
        @ret
      end
    end
  end
end
