module Shoes
  module Swt
    class Animation
      # An Swt animation implementation
      #
      # @param [Shoes::Animation] dsl The Shoes DSL Animation this represents
      # @param [Shoes::Swt::App] The Swt representation of the current app
      # @param [Proc] blk The block of code to execute for each animation frame
      def initialize(dsl, app, blk)
        @dsl = dsl
        @app = app
        @blk = blk

        # Wrap the animation block so we can count frames.
        # Note that the task re-calls itself on each run.
        @task = Proc.new do
          unless @app.real.disposed?
            @blk.call(@dsl.current_frame)
            @dsl.increment_frame unless @dsl.stopped?
            @app.real.redraw
            ::Swt.display.timer_exec(2000 / @dsl.framerate, @task) unless @dsl.removed?
          end
        end
        ::Swt.display.timer_exec(2000 / @dsl.framerate, @task)
      end

      attr_reader :task
    end
  end
end
