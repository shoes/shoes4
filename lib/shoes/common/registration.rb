class Shoes
  module Common
    module Registration
      def apps
        @apps ||= []
        @apps.dup
      end

      def register(app)
        register_main_app app
        apps && @apps << app
      end

      def unregister(app)
        apps && @apps.delete(app)
      end

      def unregister_all
        @main_app = nil
        @apps = []
      end

      attr_reader :main_app

      # Registers the first app as the main app
      def register_main_app(app)
        @main_app ||= app
      end
    end
  end
end
