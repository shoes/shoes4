class Shoes
  module Mock
    class App

      attr_accessor :fullscreen
      def initialize(dsl)
        @dsl = dsl
      end

      # suboptimal but good enough fo now... calling the DSL lets the methods
      # play ping pong calling each other... will think of something.
      def width
        @dsl.opts[:width]
      end

      def height
        @dsl.opts[:height]
      end

      def open
      end

      def quit
      end
      
      def started?
        true
      end

      def flush
      end

      def clipboard
      end

      def clipboard=(text)
      end

      def gutter
        16
      end
    end
  end
end
