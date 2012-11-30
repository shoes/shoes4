require 'java'
# TODO: Remove when merged upstream (v0.14?)
require 'swt/full-monkeypatch'
# TODO: Remove when merged upstream (v0.14?)
# Force-load our fixed jar_loader.rb
$LOAD_PATH.unshift File.expand_path('../../swt', __FILE__)
require 'jar_loader'
$LOAD_PATH.shift
require 'swt'

module Swt
  include_package 'org.eclipse.swt.graphics'
  include_package 'org.eclipse.swt.events'
  module Widgets
    import org.eclipse.swt.widgets
    import org.eclipse.swt.widgets.Layout
  end
  module Graphics
    import org.eclipse.swt.graphics
    import org.eclipse.swt.graphics.Pattern
  end
end

def window(*a, &b)
  Shoes.app(*a, &b)
end

require 'shoes/swt/common/fill'
require 'shoes/swt/common/stroke'
require 'shoes/swt/common/move'
require 'shoes/swt/common/child'
require 'shoes/swt/common/container'
require 'shoes/swt/common/resource'
require 'shoes/swt/common/painter'
require 'shoes/swt/common/clickable'
require 'shoes/swt/common/toggle'
require 'shoes/swt/common/clear'
require 'shoes/swt/alert'
require 'shoes/swt/layout'
require 'shoes/swt/app'

# require 'shoes/swt/window'
require 'shoes/swt/animation'
require 'shoes/swt/arc'
require 'shoes/swt/background'
require 'shoes/swt/border'
require 'shoes/swt/button'
require 'shoes/swt/check'
require 'shoes/swt/color'
require 'shoes/swt/edit_box'
require 'shoes/swt/edit_line'
require 'shoes/swt/gradient'
require 'shoes/swt/image'
require 'shoes/swt/image_pattern'
require 'shoes/swt/keypress'
require 'shoes/swt/line'
require 'shoes/swt/list_box'
require 'shoes/swt/oval'
require 'shoes/swt/progress'
require 'shoes/swt/radio'
require 'shoes/swt/rect'
require 'shoes/swt/shape'
require 'shoes/swt/slot'
require 'shoes/swt/sound'
require 'shoes/swt/text_block'
require 'shoes/swt/timer'

module Shoes::Swt
  extend ::Shoes::Common::Registration

  module Shoes
    def self.app(opts={}, &blk)
      Shoes::App.new(opts, &blk)
      Shoes.logger.debug "Exiting Shoes.app"
    end

    def self.logger
      ::Shoes.logger
    end

    def self.display
      ::Swt::Widgets::Display.getCurrent
    end
  end
end

