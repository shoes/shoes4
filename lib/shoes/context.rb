class Shoes
  class Context
    include DSL
    include BuiltinMethods
    include Common::Clickable

    class Privates
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def element_styles
        @app.element_styles
      end

      def style
        @app.style
      end

      def current_slot
        @app.current_slot
      end
    end

    def initialize(app)
      @__privates__ = Privates.new(app)
    end

    def instance_variables
      super - [:@__privates__]
    end

    def execute(&block)
      self.instance_eval &block
    end
  end
end
