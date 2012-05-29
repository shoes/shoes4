require 'rubygems'
require 'facets/hash'

module Shoes
  class << self
    def logger
      Shoes.configuration.logger_instance
    end
  end
end

require 'shoes/app'
#require 'shoes/native'
#require 'shoes/element_methods'
require 'shoes/animation'
#require 'shoes/runnable_block'
#require 'shoes/timer_base'
#require 'shoes/layout'
require 'shoes/button'
#require 'shoes/stack'
require 'shoes/flow'
#require 'shoes/edit_line'
#require 'shoes/edit_box'
#require 'shoes/check'
#require 'shoes/image'
require 'shoes/line'
require 'shoes/oval'
require 'shoes/sound'
require 'shoes/shape'
require 'shoes/configuration'
require 'shoes/logger'
