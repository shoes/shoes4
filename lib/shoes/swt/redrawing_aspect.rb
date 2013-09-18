# This file uses the after gem, which you probably haven't heard of (yet)
# It basically works like Class.after :method do ... end
# So for every instance of Class, after method is executed the block you
# gave it is executed.
# Here it is used to redraw the application, after specific methods are called.
# So that everything belonging to the aspect of redrawing is in one file.
# There will be more documentation up here: https://github.com/PragTob/after_do
# soon :-)

class Shoes
  module Swt
    class RedrawingAspect

      NEED_TO_FLUSH_GUI = {Animation          => [:eval_block],
                           Button             => [:eval_block],
                           KeypressListener   => [:eval_block],
                           KeyreleaseListener => [:eval_block],
                           Timer              => [:eval_block]}

      NEED_TO_REDRAW_GUI = {::Shoes::App   => [:oval, :star, :line,
                                               :rect, :background, :arc],
                            ::Shoes::Oval  => [:change_style],
                            ::Shoes::Rect  => [:change_style],
                            ::Shoes::Star  => [:change_style],
                            ::Shoes::Shape => [:change_style],
                            ::Shoes::Line  => [:change_style]}

      # only the main thread may draw
      NEED_TO_ASYNC_FLUSH_GUI = {::Shoes::Download  => [:eval_block]}

      REDRAW_AFTER_MOVE_CLASSES = [::Shoes::Image, ::Shoes::Line, ::Shoes::Oval,
                                   ::Shoes::Rect, ::Shoes::Star]

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
        classes = NEED_TO_FLUSH_GUI.keys +
                  NEED_TO_REDRAW_GUI.keys +
                  NEED_TO_ASYNC_FLUSH_GUI.keys +
                  REDRAW_AFTER_MOVE_CLASSES
        classes.uniq
      end

      def add_redraws
        after_every NEED_TO_FLUSH_GUI do app.flush unless app.disposed? end
        after_every NEED_TO_REDRAW_GUI do app.real.redraw unless app.disposed? end
        after_every NEED_TO_ASYNC_FLUSH_GUI do
          @display.asyncExec do app.flush unless app.disposed? end
        end
        redraws_for_move
      end

      def redraws_for_move
        after_every_call_of REDRAW_AFTER_MOVE_CLASSES, :before_move_hook do |dsl|
          gui = dsl.gui
          unless gui.container.disposed?
            gui.container.redraw dsl.absolute_left, dsl.absolute_top,
                                 dsl.width, dsl.height, false
          end
        end
        after_every_call_of REDRAW_AFTER_MOVE_CLASSES, :move do |x, y, dsl|
          gui = dsl.gui
          unless gui.container.disposed?
            gui.container.redraw x, y, dsl.width, dsl.height, false
          end
        end
      end

      def after_every_call_of(classes, method, &blk)
        classes.each do |klass| klass.after method, &blk end
      end

      def after_every(hash, &blk)
        hash.each {|klass, methods| klass.after methods, &blk }
      end
    end
  end
end