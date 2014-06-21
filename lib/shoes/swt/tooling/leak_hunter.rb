require 'swt'
require 'shoes/swt'
# Interested what hometown is and what it does?
# check here: https://github.com/jasonrclark/hometown
require 'hometown'

# All known subclasses of Swt::Graphics::Resource
# see http://help.eclipse.org/helios/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fswt%2Fpackage-summary.html
[
  ::Swt::Graphics::Color,
  ::Swt::Graphics::Cursor,
  ::Swt::Graphics::Font,
  ::Swt::Graphics::Image,
  ::Swt::Graphics::Path,
  ::Swt::Graphics::Pattern,
  ::Swt::Graphics::Region,
  ::Swt::Graphics::TextLayout,
  ::Swt::Graphics::Transform,

  # Excluded GC as we don't create any directly and it's quite noisy
  #::Swt::Graphics::GC,
].each do |clazz|
  Hometown.watch_for_disposal(clazz, :dispose)
end

Hometown.undisposed_report_at_exit

# Register an internal keystroke for closing the app, making sure to clear
# out the contents first (to avoid false positives for still-exiting elements.
Shoes::InternalApp.add_global_keypress(:'control_alt_q') do
  clear
  quit
end

puts "Registered Ctrl+Alt+Q for leak hunting clean shutdown."
