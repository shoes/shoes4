class Shoes
  module Common
    module Hover
      attr_reader :hover_blk, :leave_blk

      def hover(&blk)
        @hover_blk = blk
        app.add_mouse_hover_control(self)
      end

      def leave(&blk)
        @leave_blk = blk
        app.add_mouse_hover_control(self)
      end

      def hovered?
        @hovered
      end

      def eval_in_parent?
        false
      end

      def mouse_hovered
        return if @hovered

        @hovered = true

        target = self
        target = parent if eval_in_parent?
        target.eval_hover_block(@hover_blk)
      end

      def mouse_left
        return unless @hovered

        @hovered = false

        target = self
        target = parent if eval_in_parent?
        target.eval_hover_block(@leave_blk)
      end

      def eval_hover_block(blk)
        blk.call(self) if blk
      end
    end
  end
end
