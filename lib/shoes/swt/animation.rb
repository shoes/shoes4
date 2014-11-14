class Shoes
  module Swt
    class Animation
      attr_reader :task

      # An Swt animation implementation
      #
      # @param [Shoes::Animation] dsl The Shoes DSL Animation this represents
      # @param [Shoes::Swt::App] app The Swt representation of the current app
      # @param [Proc] blk The block of code to execute for each animation frame
      def initialize(dsl, app)
        @dsl = dsl
        @app = app

        # Wrap the animation block so we can count frames.
        # Note that the task re-calls itself on each run.
        @task = proc do
          unless animation_removed?
            run_animation unless @dsl.stopped?
            schedule_next_animation
          end
        end
        schedule_next_animation
      end

      def eval_block
        @dsl.blk.call(@dsl.current_frame)
      end

      private

      def animation_removed?
        @app.real.disposed? || @dsl.removed?
      end

      def schedule_next_animation
        ::Swt.display.timer_exec(1000 / @dsl.framerate, @task)
      end

      def run_animation
        eval_block
        @dsl.increment_frame
      end
    end
  end
end
