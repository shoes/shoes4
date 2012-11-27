# The methods defined in this module/file are also available outside of the
# Shoes.app block. So they are monkey patched onto the main object.
# However they can also be used from the normal Shoes.app block.
module Shoes
  module GlobalMethods
    def alert(message = '')
      Shoes::Alert.new @current_slot, message
    end
  end
end

# including the module into the main object
class << self
  include Shoes::GlobalMethods
end