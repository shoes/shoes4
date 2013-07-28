class Shoes
  module Swt
    class Keyrelease < Keyevent
      def initialize dsl, app, &blk
        super(dsl, app, :released, &blk)
      end
    end
  end
end