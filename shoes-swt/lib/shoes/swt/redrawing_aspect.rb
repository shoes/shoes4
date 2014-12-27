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
      NEED_TO_UPDATE =
          { Animation                        => [:eval_block],
            Button                           => [:eval_block],
            ClickListener                    => [:eval_block],
            ::Shoes::InternalApp             => [:execute_block],
            Keypress                         => [:eval_block],
            Keyrelease                       => [:eval_block],
            MouseMoveListener                => [:eval_move_block],
            TextBlock::CursorPainter         => [:move_textcursor],
            Timer                            => [:eval_block],
            ::Shoes::Common::Changeable      => [:call_change_listeners] }
      # only the main thread may draw
      NEED_TO_ASYNC_UPDATE_GUI = { ::Shoes::Download => [:eval_block] }

      # These need to trigger a redraw
      SAME_POSITION    = { Common::Visibility      => [:update_visibility],
                           Image                   => [:update_image],
                           ::Shoes::Common::Style  => [:update_style],
                           ::Shoes::Common::Remove => [:remove],
                           ::Shoes::Slot           => [:mouse_hovered,
                                                       :mouse_left],
                           ::Shoes::TextBlock      => [:replace] }

      CHANGED_POSITION = { ::Shoes::Common::Positioning => [:_position] }

      # These methods trigger SWT painting listeners, so we need to be sure
      # that positioning has run properly before allowing them to continue.
      NEED_CONTENTS_ALIGNMENT = {
        ::Shoes::Swt::Dialog    => [:ask_color,
                                    :dialog_chooser,
                                    :open_message_box]
      }

      attr_reader :app

      def initialize(swt_app, display)
        @app = swt_app
        @display = display
        extend_needed_classes
        add_redraws
      end

      def remove_redraws
        affected_classes.each(&:remove_all_callbacks)
      end

      private

      def extend_needed_classes
        affected_classes.each { |klass| klass.extend AfterDo }
      end

      def affected_classes
        classes = NEED_TO_UPDATE.keys +
                  NEED_TO_ASYNC_UPDATE_GUI.keys +
                  NEED_CONTENTS_ALIGNMENT.keys +
                  SAME_POSITION.keys +
                  CHANGED_POSITION.keys
        classes.uniq
      end

      def add_redraws
        after_every NEED_TO_UPDATE do update_gui end
        after_every NEED_TO_ASYNC_UPDATE_GUI do
          @display.asyncExec { update_gui }
        end
        after_every SAME_POSITION do |*_args, element|
          element = element.dsl if element.respond_to? :dsl
          redraw_element element, false
        end
        # need to redraw old occupied area and newly occupied area
        before_and_after_every CHANGED_POSITION do |*_args, element|
          redraw_element element
        end
        before_every NEED_CONTENTS_ALIGNMENT do |*_args|
          app.dsl.top_slot.contents_alignment
        end
      end

      def update_gui
        app.flush unless app.disposed?
      end

      def redraw_element(element, include_children = true)
        redraw_area element.element_left, element.element_top,
                    element.element_width, element.element_height,
                    include_children
      end

      def redraw_area(left, top, width, height, include_children = true)
        unless app.disposed?
          app.redraw left, top, width, height, include_children
        end
      end

      def after_every(hash, &blk)
        hash.each { |klass, methods| klass.after methods, &blk }
      end

      def before_and_after_every(hash, &blk)
        before_every hash, &blk
        after_every hash, &blk
      end

      def before_every(hash, &blk)
        hash.each { |klass, methods| klass.before methods, &blk }
      end
    end
  end
end
