module Shoes
  module Common
    module Registration
      def apps
        @apps ||= []
      end

      def register(app)
        register_main_app app
        apps << app
      end

      def unregister(app)
        apps.delete app
      end

      def main_app
        @main_app
      end

      # Registers the first app as the main app
      def register_main_app(app)
        @main_app ||= app
      end
    end
  end
end
