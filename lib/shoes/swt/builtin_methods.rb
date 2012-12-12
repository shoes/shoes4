# The methods defined in this module/file are also available outside of the
# Shoes.app block. So they are monkey patched onto the main object.
# However they can also be used from the normal Shoes.app block.
module Shoes
  module Swt
    module BuiltinMethods
      def alert(message = '')
        ::Shoes::Swt::Alert.new message
        nil
      end

      def confirm(message = '')
        ::Shoes::Swt::Confirm.new(@current_slot, message).confirmed?
      end
    end
  end
end

# including the module into the main object
class << self
  include Shoes::Swt::BuiltinMethods
end