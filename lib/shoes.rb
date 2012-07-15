require 'rubygems'

module Shoes
  class << self
    def logger
      Shoes.configuration.logger_instance
    end
  end
end

require 'shoes/version'
require 'shoes/app'
require 'shoes/progress'
#require 'shoes/native'
#require 'shoes/element_methods'
require 'shoes/animation'
require 'shoes/app'
require 'shoes/background'
require 'shoes/border'
require 'shoes/button'
require 'shoes/list_box'
#require 'shoes/stack'
require 'shoes/flow'
require 'shoes/edit_line'
#require 'shoes/edit_box'
require 'shoes/check'
#require 'shoes/image'
require 'shoes/line'
require 'shoes/oval'
require 'shoes/sound'
require 'shoes/shape'
require 'shoes/configuration'
require 'shoes/logger'
require 'shoes/text_block'
require 'shoes/radio'
