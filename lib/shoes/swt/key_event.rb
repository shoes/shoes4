class Shoes
  module Swt
    class KeyEvent
      def initialize dsl, app, &blk
        @shell = app.shell
        @key_listener = create_key_listener &blk
        @shell.add_key_listener @key_listener
      end

      def create_key_listener(&blk)
        raise 'subclass responsibility'
      end

      def clear
        @shell.remove_key_listener @key_listener
      end
    end

    class Keypress < KeyEvent
      def create_key_listener(&blk)
        KeypressListener.new blk
      end
    end

    class Keyrelease < KeyEvent
      def create_key_listener(&blk)
        KeyreleaseListener.new blk
      end
    end
  end
end
