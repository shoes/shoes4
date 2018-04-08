# frozen_string_literal: true

class Shoes
  module DSL
    module Animate
      # Creates an animation that runs the given block of code.
      # Defaults to framerate of 24 frames per second
      #
      # @overload animate(framerate = 24, opts = {}, &blk)
      #   @param [Integer] framerate frames per second
      #   @param [Hash] opts
      #   @param [Proc] blk code to run for each animation frame
      #   @option opts [Integer] :framerate Frames per second
      #   @return [Shoes::Animation]
      #
      #   @example
      #     # 10 frames per second
      #     animate 10 do
      #       # animation code
      #     end
      def animate(opts = {}, &blk)
        opts = { framerate: opts } unless opts.is_a? Hash
        Shoes::Animation.new @__app__, opts, blk
      end

      # Runs the associated block every N seconds
      #
      # @overload every(n = 1, opts = {}, &blk)
      #   @param [Integer] n run every n seconds
      #   @param [Proc] blk code to run each n seconds
      #   @return [Shoes::Animation]
      def every(n = 1, &blk)
        animate 1.0 / n, &blk
      end

      # Runs the associated block every N seconds
      #
      # @overload timer(n = 1, opts = {}, &blk)
      #   @param [Integer] n run every n seconds
      #   @param [Proc] blk code to run each n seconds
      #   @return [Shoes::Timer]
      def timer(n = 1, &blk)
        n *= 1000
        Timer.new @__app__, n, &blk
      end
    end
  end
end
