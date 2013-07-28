class Shoes
  module Swt
    class Keypress < Keyevent
      def initialize dsl, app, &blk
        super(dsl, app, :pressed, &blk)
      end
    end
  end
end