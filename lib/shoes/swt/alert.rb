class Object
  def alert msg
    shell = Swt::Widgets::Shell.new Swt.display
    mb = Swt::Widgets::MessageBox.new shell, Swt::SWT::OK | Swt::SWT::ICON_INFORMATION
    mb.setMessage msg.to_s
    mb.open
  end
end
