require 'java'
require 'swt'
require 'after_do'

module Swt
  include_package 'org.eclipse.swt.graphics'
  include_package 'org.eclipse.swt.events'
  include_package 'org.eclipse.swt.dnd'

  module Events
    import org.eclipse.swt.events.PaintListener
  end

  module Widgets
    import org.eclipse.swt.widgets
    import org.eclipse.swt.widgets.Layout
  end

  module Graphics
    import org.eclipse.swt.graphics
    import org.eclipse.swt.graphics.Pattern
  end
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

require 'shoes/swt/app'
require 'shoes/swt/animation'
require 'shoes/swt/arc'
require 'shoes/swt/background'
require 'shoes/swt/border'
require 'shoes/swt/button'
require 'shoes/swt/check'
require 'shoes/swt/color'
require 'shoes/swt/dialog'
require 'shoes/swt/edit_box'
require 'shoes/swt/edit_line'
require 'shoes/swt/gradient'
require 'shoes/swt/image'
require 'shoes/swt/image_pattern'
require 'shoes/swt/keypress'
require 'shoes/swt/layout'
require 'shoes/swt/line'
require 'shoes/swt/list_box'
require 'shoes/swt/oval'
require 'shoes/swt/progress'
require 'shoes/swt/radio'
require 'shoes/swt/rect'
require 'shoes/swt/star'
require 'shoes/swt/shape'
require 'shoes/swt/slot'
require 'shoes/swt/sound'
require 'shoes/swt/text_block'
require 'shoes/swt/timer'

class Shoes
  module Swt
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

      ::Swt::Widgets::Display.new.getFontList(nil, true).each{|f| ::Shoes::FONTS << f.getName}
      ::Shoes::FONTS.uniq!
    end
  end
end

Shoes.configuration.backend = :swt
require 'shoes/swt/font'
require 'shoes/swt/redrawing_aspect'

