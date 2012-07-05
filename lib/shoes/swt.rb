require 'java'
require 'swt'

module Swt
  include_package 'org.eclipse.swt.graphics'
  include_package 'org.eclipse.swt.events'
end

def window(*a, &b)
  Shoes.app(*a, &b)
end

require 'shoes/swt/common/fill'
require 'shoes/swt/common/stroke'
require 'shoes/swt/common/child'
require 'shoes/swt/common/container'
require 'shoes/swt/element_methods'
require 'shoes/swt/animation'
require 'shoes/swt/app'
require 'shoes/swt/progress'
#require 'shoes/swt/window'
require 'shoes/swt/flow'
require 'shoes/swt/button'
require 'shoes/swt/line'
require 'shoes/swt/oval'
require 'shoes/swt/shape'
require 'shoes/swt/color'
require 'shoes/swt/sound'
require 'shoes/swt/text_block'
require 'shoes/swt/list_box'
require 'shoes/swt/radio'
require 'shoes/swt/check'

module Shoes::Swt
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


