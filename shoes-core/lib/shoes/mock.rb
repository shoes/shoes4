# frozen_string_literal: true

class Shoes
  module Mock
    def self.initialize_backend(*_); end
  end
end

require 'shoes/mock/common_methods'
require 'shoes/mock/clickable'

require 'shoes/mock/packager'

require 'shoes/mock/animation'
require 'shoes/mock/app'
require 'shoes/mock/arc'
require 'shoes/mock/arrow'
require 'shoes/mock/background'
require 'shoes/mock/border'
require 'shoes/mock/button'
require 'shoes/mock/check'
require 'shoes/mock/download'
require 'shoes/mock/font'
require 'shoes/mock/image'
require 'shoes/mock/image_pattern'
require 'shoes/mock/input_box'
require 'shoes/mock/keypress'
require 'shoes/mock/keyrelease'
require 'shoes/mock/line'
require 'shoes/mock/link'
require 'shoes/mock/list_box'
require 'shoes/mock/oval'
require 'shoes/mock/progress'
require 'shoes/mock/radio'
require 'shoes/mock/rect'
require 'shoes/mock/star'
require 'shoes/mock/shape'
require 'shoes/mock/slot'
require 'shoes/mock/sound'
require 'shoes/mock/text_block'
require 'shoes/mock/dialog'
require 'shoes/mock/timer'
