# frozen_string_literal: true

require 'java'

# Try to load modern SWT with ARM64 support
begin
  require 'glimmer-dsl-swt'
  
  glimmer_gem_path = Gem::Specification.find_by_name('glimmer-dsl-swt').gem_dir
  
  # Determine the correct SWT jar based on platform
  require 'rbconfig'
  swt_path = case RbConfig::CONFIG["host_os"]
  when /darwin/i
    cpu = RbConfig::CONFIG["host_cpu"]
    if cpu == "arm64" || cpu == "aarch64"
      File.join(glimmer_gem_path, 'vendor', 'swt', 'mac_aarch64', 'swt.jar')
    else
      File.join(glimmer_gem_path, 'vendor', 'swt', 'mac', 'swt.jar')
    end
  when /linux/i
    File.join(glimmer_gem_path, 'vendor', 'swt', 'linux_x86_64', 'swt.jar')
  when /windows|mswin/i
    File.join(glimmer_gem_path, 'vendor', 'swt', 'win64', 'swt.jar')
  end
  
  if File.exist?(swt_path)
    require swt_path
    puts "Loaded modern SWT (ARM64 compatible) from: #{swt_path}"
  else
    raise "SWT jar not found at #{swt_path}"
  end
rescue LoadError => e
  puts "Warning: Could not load modern SWT, falling back to legacy: #{e.message}"
  require 'swt/minimal'
  require 'swt/core'
end

require 'after_do'
require 'shoes'
require 'shoes/core'

module Swt
  include_package 'org.eclipse.swt.graphics'
  include_package 'org.eclipse.swt.events'
  include_package 'org.eclipse.swt.dnd'

  module Events
    import org.eclipse.swt.events.PaintListener
    import org.eclipse.swt.events.MouseMoveListener
  end

  module Widgets
    import org.eclipse.swt.widgets.ColorDialog
    import org.eclipse.swt.widgets.Composite
    import org.eclipse.swt.widgets.DirectoryDialog
    import org.eclipse.swt.widgets.Display
    import org.eclipse.swt.widgets.Event
    import org.eclipse.swt.widgets.FileDialog
    import org.eclipse.swt.widgets.Group
    import org.eclipse.swt.widgets.Label
    import org.eclipse.swt.widgets.Layout
    import org.eclipse.swt.widgets.Listener
    import org.eclipse.swt.widgets.Menu
    import org.eclipse.swt.widgets.MenuItem
    import org.eclipse.swt.widgets.MessageBox
    import org.eclipse.swt.widgets.Shell
    import org.eclipse.swt.widgets.ToolBar
    import org.eclipse.swt.widgets.ToolItem
  end

  module Layout
    import org.eclipse.swt.layout.FillLayout
  end

  module Graphics
    import org.eclipse.swt.graphics.Device
    import org.eclipse.swt.graphics.Font
    import org.eclipse.swt.graphics.FontData
    import org.eclipse.swt.graphics.GC
    import org.eclipse.swt.graphics.Transform
    import org.eclipse.swt.graphics.Image
    import org.eclipse.swt.graphics.ImageData
    import org.eclipse.swt.graphics.Path
    import org.eclipse.swt.graphics.Point
    import org.eclipse.swt.graphics.Region
  end

  module DND
    import org.eclipse.swt.dnd.DropTarget
    import org.eclipse.swt.dnd.DropTargetEvent
    import org.eclipse.swt.dnd.DropTargetListener
    import org.eclipse.swt.dnd.DropTargetAdapter
    import org.eclipse.swt.dnd.DND
    import org.eclipse.swt.dnd.FileTransfer
    import org.eclipse.swt.dnd.TextTransfer
    import org.eclipse.swt.dnd.Transfer
  end

  module Browser
    import org.eclipse.swt.browser.Browser
  end

  import org.eclipse.swt.SWT
  import org.eclipse.swt.SWTException
  include_package 'org.eclipse.swt.widgets'
end

# Initialize backend
::Shoes.configuration.backend = :swt

# Load common modules first
require 'shoes/swt/disposed_protection'
require 'shoes/swt/click_listener'
require 'shoes/swt/color'
require 'shoes/swt/color_factory'
require 'shoes/swt/common/remove'
require 'shoes/swt/common/clickable'
require 'shoes/swt/common/container'
require 'shoes/swt/common/fill'
require 'shoes/swt/common/focus'
require 'shoes/swt/common/image_handling'
require 'shoes/swt/common/resource'
require 'shoes/swt/common/painter'
require 'shoes/swt/common/painter_updates_position'
require 'shoes/swt/common/visibility'
require 'shoes/swt/common/selection_listener'
require 'shoes/swt/common/stroke'
require 'shoes/swt/common/translate'
require 'shoes/swt/common/update_position'

# Load input and painters
require 'shoes/swt/input_box'
require 'shoes/swt/arc_painter'
require 'shoes/swt/arrow_painter'
require 'shoes/swt/line_painter'
require 'shoes/swt/oval_painter'
require 'shoes/swt/rect_painter'
require 'shoes/swt/shape_painter'
require 'shoes/swt/star_painter'
require 'shoes/swt/swt_button'
require 'shoes/swt/check_button'
require 'shoes/swt/radio_group'
require 'shoes/swt/text_block/painter'

# Load main components
require 'shoes/swt/app'
require 'shoes/swt/animation'
require 'shoes/swt/arc'
require 'shoes/swt/background'
require 'shoes/swt/border'
require 'shoes/swt/button'
require 'shoes/swt/check'
require 'shoes/swt/dialog'
require 'shoes/swt/download'
require 'shoes/swt/font'
require 'shoes/swt/gradient'
require 'shoes/swt/image'
require 'shoes/swt/image_painter'
require 'shoes/swt/image_pattern'
require 'shoes/swt/key_listener'
require 'shoes/swt/line'
require 'shoes/swt/link'
require 'shoes/swt/link_segment'
require 'shoes/swt/list_box'
require 'shoes/swt/mouse_move_listener'
require 'shoes/swt/oval'
require 'shoes/swt/progress'
require 'shoes/swt/radio'
require 'shoes/swt/rect'
require 'shoes/swt/shape'
require 'shoes/swt/shoes_layout'
require 'shoes/swt/slot'
require 'shoes/swt/star'
require 'shoes/swt/sound'
require 'shoes/swt/text_block'
require 'shoes/swt/timer'

require 'shoes/swt/text_block/text_segment'
require 'shoes/swt/text_block/centered_text_segment'
require 'shoes/swt/text_block/text_segment_collection'
require 'shoes/swt/text_block/cursor_painter'
require 'shoes/swt/text_block/fitter'
require 'shoes/swt/text_block/text_font_factory'
require 'shoes/swt/text_block/text_style_factory'

require 'shoes/swt/packager'

# redrawing aspect needs to know all the classes
require 'shoes/swt/redrawing_aspect'

class Shoes
  module Swt
    # Backend is loaded via requires above
    def self.logger
      ::Shoes.logger
    end

    def self.display
      ::Swt::Widgets::Display.getCurrent
    end
  end
end