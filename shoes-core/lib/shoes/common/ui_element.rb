# frozen_string_literal: true
class Shoes
  module Common
    class UIElement
      include Common::Attachable
      include Common::Inspect
      include Common::Visibility
      include Common::Positioning
      include Common::Remove
      include DimensionsDelegations
      include Common::SafelyEvaluate
      include Common::Style

      attr_reader :app, :parent, :dimensions, :gui

      def initialize(app, parent, *args)
        blk    = args.pop if args.last.is_a?(Proc) || args.last.nil?
        styles = args.last.is_a?(Hash) ? args.pop : {}

        before_initialize(styles, *args)

        @app = app
        @parent = parent

        style_init(styles)
        create_dimensions(*args)
        update_dimensions if styles_with_dimensions?

        create_backend
        add_to_parent(*args)

        handle_block(blk)
        update_visibility

        after_initialize(*args)
      end

      # This method will get called with the incoming styles hash and the
      # other arguments passed to initialize.
      #
      # It is intended for performing any additions to the styles hash before
      # that gets sent on to style_init.
      def before_initialize(_styles, *_)
      end

      # Set the dimensions for the element. Defaults to using the Dimensions
      # class, but is expected to be overridden in other types (art elements,
      # text blocks) that require different dimensioning.
      def create_dimensions(*_)
        @dimensions = Dimensions.new @parent, @style
      end

      # Call to create the backend (aka @gui)
      def create_backend
        @gui = Shoes.backend_for self
      end

      # Calls to add child in parent, after the backend has been created.
      # Can be overridden for operations that must happen after backend, but
      # before addition to parent (and hence positioning)
      def add_to_parent(*_)
        @parent.add_child self
      end

      # This method handles the block passed in at creation of the DSL element.
      # By default it will treat things as clickable, and assumes the
      # necessary methods are there.
      #
      # Override if DSL element uses that block for something else (i.e. slot)
      def handle_block(blk)
        register_click blk if respond_to?(:register_click)
      end

      # Final method called in initialize. Intended for any final setup after
      # the rest of the object has been set up fully.
      def after_initialize(*_)
      end

      # Nobody rotates by default, but we need to let you check
      def needs_rotate?
        false
      end

      # Expected to be overridden by pulling in Common::Fill or Common::Stroke
      # if element needs to actually notify GUI classes of colors changes.
      def update_fill
      end

      def update_stroke
      end

      # Some element types (arrows, shapes) don't necessarily track their
      # element locations in the standard way. Let them inform redrawing about
      # the actual bounds to redraw within by overriding these methods
      def redraw_left
        element_left
      end

      def redraw_top
        element_top
      end

      def redraw_width
        element_width
      end

      def redraw_height
        element_height
      end

      def painted?
        false
      end
    end
  end
end
