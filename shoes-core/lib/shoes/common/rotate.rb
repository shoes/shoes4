class Shoes
  module Common
    module Rotate
      # By default no one can rotate. Have to enable in particular classes.
      def needs_rotate?
        false
      end
    end
  end
end
