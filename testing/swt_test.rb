  require 'java'
  require 'swt'
  class Object
    include_package 'org.eclipse.swt'
    include_package 'org.eclipse.swt.widgets'
  end
  display = Swt.display
  shell = Shell.new display
  shell.setSize 300, 300
  shell.open
  while !shell.isDisposed do
    display.sleep unless display.readAndDispatch
  end
  display.dispose
