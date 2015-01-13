class Shoes
  module Common
    module Initialization
      def initialize(app, parent, *args)
        blk    = args.pop if args.last.is_a?(Proc) || args.last.nil?
        styles = args.last.is_a?(Hash) ? args.pop : {}

        before_initialize(styles)

        @app = app
        @parent = parent

        style_init(styles)
        create_dimensions(*args)

        @parent.add_child self
        @gui = Shoes.backend_for self

        register_click blk if blk

        after_initialize
      end

      def create_dimensions(args)
        raise NotImplementedError.new
      end

      def before_initialize(styles)
      end

      def after_initialize
      end
    end
  end
end
