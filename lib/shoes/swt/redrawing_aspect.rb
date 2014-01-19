# This file uses the after_do gem, which you probably haven't heard of (yet)
# It basically works like Class.after :method do ... end
# So for every instance of Class, after method is executed the block you
# gave it is executed.
# Here it is used to redraw the application, after specific methods are called.
# So that everything belonging to the aspect of redrawing is in one file.
# There is more documentation up here: https://github.com/PragTob/after_do

class Shoes
  module Swt
    class RedrawingAspect

      NEED_TO_UPDATE = {Animation                        => [:eval_block],
                        Button                           => [:eval_block],
                        Common::Clickable::ClickListener => [:eval_block],
                        ::Shoes::InternalApp             => [:execute_block],
                        KeypressListener                 => [:eval_block],
                        KeyreleaseListener               => [:eval_block],
                        MouseMoveListener                => [:eval_move_block],
                        TextBlockCursorPainter           => [:move_textcursor],
                        Timer                            => [:eval_block]}
      # only the main thread may draw
      NEED_TO_ASYNC_UPDATE_GUI = {::Shoes::Download => [:eval_block]}

      # These need to trigger a redraw
      SAME_POSITION    = {Common::Toggle  => [:toggle]}
      CHANGED_POSITION = {TextBlock       => [:update_position]}

      attr_reader :app

      def initialize(swt_app, display)
        @app = swt_app
        @display = display
        extend_needed_classes
        add_redraws
      end

      def remove_redraws
        affected_classes.each {|klass| klass.remove_all_callbacks}
      end

      private
      def extend_needed_classes
        affected_classes.each {|klass| klass.extend AfterDo}
      end

      def affected_classes
        classes = NEED_TO_UPDATE.keys +
                  NEED_TO_ASYNC_UPDATE_GUI.keys +
                  SAME_POSITION.keys +
                  CHANGED_POSITION.keys
        classes.uniq
      end

      def add_redraws
        after_every NEED_TO_UPDATE do update_gui end
        after_every NEED_TO_ASYNC_UPDATE_GUI do
          @display.asyncExec do update_gui end
        end
        after_every SAME_POSITION do |*args, element|
          redraw_area element.element_left, element.element_top,
                      element.element_width, element.element_height, false
        end
        after_every CHANGED_POSITION do
          app.redraw
        end
      end

      # If/when we run into performance problems we can do this a lot more fine
      # grained, e.g. when an object moves we only have to redraw the old
      # and the new position of the screen not everything but premature
      # optimization etc. and it's not that easy for elements that are layouted
      def update_gui
        unless app.disposed?
          app.flush
          app.redraw
        end
      end

      def redraw_area(left, top, width, height, include_children = true)
        unless app.disposed?
          app.redraw left, top, width, height, include_children
        end
      end

      def after_every(hash, &blk)
        hash.each {|klass, methods| klass.after methods, &blk }
      end
    end
  end
end
