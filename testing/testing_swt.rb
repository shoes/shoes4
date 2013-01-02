require 'swt'

WIDTH = 500
HEIGHT = 400

# comment out for expected behaviour (and comment in the other shell definition)
#@shell = ::Swt::Widgets::Shell.new(::Swt.display, ::Swt::SWT::V_SCROLL)
#vb = @shell.getVerticalBar
#puts 'vb size x: ' + vb.getSize.x.to_s

@shell = ::Swt::Widgets::Shell.new(::Swt.display)
puts "what clienat area width should be: " + WIDTH.to_s
@shell.setBounds(@shell.computeTrim(100, 100, WIDTH, HEIGHT))
puts "What client area width actually is " + @shell.getClientArea.width.to_s
