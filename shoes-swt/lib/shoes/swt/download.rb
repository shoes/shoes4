# frozen_string_literal: true
class Shoes
  module Swt
    class Download
      attr_accessor :busy
      def initialize(_dsl, _app)
        @busy = false
      end

      # This exists to guarantee the callback block for download completion
      # executes on the main UI thread. Without it we get thread access errors.
      def eval_block(blk, result)
        ::Swt.display.asyncExec do
          actually_run_block(blk, result)
        end
      end

      # Why a separate method? So RedrawingAspect can target it!
      def actually_run_block(blk, result)
        blk.call result
        @busy = false
      end

      def busy?
        @busy
      end
    end
  end
end
