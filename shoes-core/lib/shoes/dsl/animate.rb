# frozen_string_literal: true

class Shoes
  module DSL
    module Animate
      # Creates an animation that runs the given block of code.
      #
      # @overload animate &blk
      #   @param [Proc] blk Code to run for each animation frame
      #   @return [Shoes::Animation]
      #   Defaults to framerate of 24 frames per second
      #   @example
      #     # 24 frames per second
      #     animate do
      #       # animation code
      #     end
      # @overload animate(framerate, &blk)
      #   @param [Integer] framerate Frames per second
      #   @param [Proc] blk Code to run for each animation frame
      #   @return [Shoes::Animation]
      #   @example
      #     # 10 frames per second
      #     animate 10 do
      #       # animation code
      #     end
      # @overload animate(opts = {}, &blk)
      #   @param [Hash] opts Animation options
      #   @param [Proc] blk Code to run for each animation frame
      #   @option opts [Integer] :framerate Frames per second
      #   @return [Shoes::Animation]
      #   @example
      #     # 10 frames per second
      #     animate :framerate => 10 do
      #       # animation code
      #     end
      #
      def animate(opts = {}, &blk)
        opts = { framerate: opts } unless opts.is_a? Hash
        Shoes::Animation.new @__app__, opts, blk
      end

      def every(n = 1, &blk)
        animate 1.0 / n, &blk
      end

      def timer(n = 1, &blk)
        n *= 1000
        Timer.new @__app__, n, &blk
      end
    end
  end
end
