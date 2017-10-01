# frozen_string_literal: true
class Shoes
  # This is the superclass for creating custom Shoes widgets.
  #
  # To use, inherit from {Shoes::Widget}. You get a few magical effects:
  #
  # * When you inherit from {Shoes::Widget}, you get a method in your Apps to
  #   create your widgets. The method is lower- and snake-cased. It returns
  #   an instance of your widget class.
  # * Your widgets delegate missing methods to their app object. This
  #   allows you to use the Shoes DSL within your widgets.
  #
  # @example
  #   class SayHello < Shoes::Widget
  #     def initialize word
  #       para "Hello #{word}", stroke: green, size: 80
  #     end
  #   end
  #
  #   Shoes.app do
  #     say_hello 'Shoes'
  #   end
  #
  class Widget < Shoes::Flow
    Shoes::App.subscribe_to_dsl_methods self

    attr_accessor :original_args

    def handle_block(*_)
      old_current_slot = @app.current_slot
      @app.current_slot = self
      initialize(*original_args)
      @app.current_slot = old_current_slot
    end

    def shoes_base_class
      Shoes::Widget
    end

    def self.inherited(klass, &_blk)
      # Ensure Hover styling class exists, but Widget gets hover behavior from parents
      Shoes::Common::Hover.create_hover_class(klass)

      dsl_method = dsl_method_name(klass)
      Shoes::App.new_dsl_method(dsl_method) do |*args|
        # If last arg is a Hash, pass that to the underlying Flow
        container_args = args.last.is_a?(Hash) ? args.last : {}

        # What's this business? Because of the old contract about how widgets
        # define initialize, we actually have TWO initializes we need to call--
        # the base UIElement one and the user-defined one which doesn't super.
        #
        # Instead of using new, we take over for that by calling allocate
        # ourselves, then invoking the base-initialize equivalent, which in
        # turn (via handle_block above) will do the widget class's initialize.
        widget_instance = klass.allocate
        widget_instance.original_args = args
        widget_instance.actual_initialize(@__app__, @__app__.current_slot, container_args)
        widget_instance
      end
    end

    def self.dsl_method_name(klass)
      klass.to_s[/(^|::)(\w+)$/, 2]
           .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
           .gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end
  end
end
