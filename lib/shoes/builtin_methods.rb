# The methods defined in this module/file are also available outside of the
# Shoes.app block. So they are monkey patched onto the main object.
# However they can also be used from the normal Shoes.app block.
module Shoes
  module BuiltinMethods
    def alert(message = '')
      Shoes::Dialog.new.alert message
    end

    def confirm(message = '')
      Shoes::Dialog.new.confirm(message)
    end

    alias_method :confirm?, :confirm
  end
end

# including the module into the main object (monkey patch)
class << self
  include Shoes::BuiltinMethods
end