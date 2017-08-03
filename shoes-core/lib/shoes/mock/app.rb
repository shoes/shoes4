# frozen_string_literal: true
class Shoes
  module Mock
    class App
      attr_accessor :fullscreen
      def initialize(dsl)
        @dsl = dsl
        @started = false
      end

      # suboptimal but good enough for now... calling the DSL lets the methods
      # play ping pong calling each other... will think of something.
      def width
        @dsl.opts[:width]
      end

      def height
        @dsl.opts[:height]
      end

      def open
        @started = true
        self.fullscreen = true if @dsl.start_as_fullscreen?
      end

      def open?
        true
      end

      def focus
        true
      end

      def quit
      end

      def started?
        @started
      end

      def flush
      end

      def clipboard
      end

      def clipboard=(_text)
      end

      def gutter
        16
      end

      def wait_until_closed
      end

      def click(_blk)
      end

      def release(_blk)
      end
    end
  end
end
