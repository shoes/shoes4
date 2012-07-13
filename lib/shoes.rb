require 'rubygems'

module Shoes
  class << self
    def logger
      Shoes.configuration.logger_instance
    end
  end
end

#require 'shoes/edit_box'
#require 'shoes/element_methods'
#require 'shoes/image'
#require 'shoes/layout'
#require 'shoes/native'
#require 'shoes/runnable_block'
#require 'shoes/stack'
require 'shoes/animation'
require 'shoes/app'
require 'shoes/background'
require 'shoes/button'
require 'shoes/check'
require 'shoes/configuration'
require 'shoes/edit_line'
require 'shoes/flow'
require 'shoes/line'
require 'shoes/list_box'
require 'shoes/logger'
require 'shoes/oval'
require 'shoes/progress'
require 'shoes/radio'
require 'shoes/shape'
require 'shoes/sound'
require 'shoes/text_block'
require 'shoes/version'
