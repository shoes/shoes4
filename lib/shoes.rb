require 'facets/hash'

require 'support/log4j-1.2.16.jar'
require 'log4jruby'
require 'log4jruby/logger_for_class'

module Shoes
  attr_accessor :logger
  def self.logger
    @logger
  end

  @logger = Log4jruby::Logger.get('test', :tracing => true, :level => :debug)
  @logger.debug("Shoooes!")
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
