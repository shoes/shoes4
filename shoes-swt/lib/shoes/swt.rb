require 'java'
require 'swt'
require 'after_do'
require 'shoes'

module Swt
  include_package 'org.eclipse.swt.graphics'
  include_package 'org.eclipse.swt.events'
  include_package 'org.eclipse.swt.dnd'

  module Events
    import org.eclipse.swt.events.PaintListener
    import org.eclipse.swt.events.MouseMoveListener
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

class Shoes
  module Swt
    extend ::Shoes::Common::Registration

    module Shoes
      def self.app(opts = {}, &blk)
        Shoes::App.new(opts, &blk)
        Shoes.logger.debug "Exiting Shoes.app"
      end

      def self.logger
        ::Shoes.logger
      end

      def self.display
        ::Swt::Widgets::Display.getCurrent
      end

      ::Swt::Widgets::Display.new.getFontList(nil, true).each { |f| ::Shoes::FONTS << f.getName }
      ::Shoes::FONTS.uniq!
    end
  end
end

Shoes.configuration.backend = :swt

require 'shoes/swt/disposed_protection'
require 'shoes/swt/click_listener'
require 'shoes/swt/color'
require 'shoes/swt/color_factory'
require 'shoes/swt/common/child'
require 'shoes/swt/common/remove'
require 'shoes/swt/common/clickable'
require 'shoes/swt/common/container'
require 'shoes/swt/common/fill'
require 'shoes/swt/common/resource'
require 'shoes/swt/common/painter'
require 'shoes/swt/common/painter_updates_position'
require 'shoes/swt/common/visibility'
require 'shoes/swt/common/selection_listener'
require 'shoes/swt/common/stroke'
require 'shoes/swt/common/update_position'

require 'shoes/swt/input_box'
require 'shoes/swt/rect_painter.rb'
require 'shoes/swt/swt_button'
require 'shoes/swt/check_button'
require 'shoes/swt/radio_group'
require 'shoes/swt/text_block/painter'

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

require 'shoes/swt/tooling/leak_hunter' if ENV["LEAK_HUNTER"]

# redrawing aspect needs to know all the classes
require 'shoes/swt/redrawing_aspect'
