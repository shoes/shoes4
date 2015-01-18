class Shoes
  module Common
    module Initialization
      def initialize(app, parent, *args)
        blk    = args.pop if args.last.is_a?(Proc) || args.last.nil?
        styles = args.last.is_a?(Hash) ? args.pop : {}

        before_initialize(styles, *args)

        @app = app
        @parent = parent

        style_init(styles)
        create_dimensions(*args)

        @parent.add_child self
        @gui = Shoes.backend_for self

        handle_block(blk)

        after_initialize(*args)
      end

      def create_dimensions(*args)
        @dimensions = Dimensions.new @parent, @style
      end

      def handle_block(blk)
        return unless blk
        register_click blk
      end

      def before_initialize(styles, *_)
      end

      def after_initialize(*_)
      end
    end
  end
end
