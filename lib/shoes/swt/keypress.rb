module Shoes
  module Swt
    class Keypress
      def initialize dsl, app, &blk
        @dsl = dsl
        @app = app
        @shell = app.shell
        @kl = ShoesKeyListener.new blk
        @shell.add_key_listener @kl
      end
      
      def clear
        @shell.remove_key_listener @kl
      end
    end
  end
end
