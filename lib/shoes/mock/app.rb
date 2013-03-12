module Shoes
  module Mock
    class App
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
      
      def started
      end
    end
  end
end
