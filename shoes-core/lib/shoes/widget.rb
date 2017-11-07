# frozen_string_literal: true

class Shoes
  # This is the superclass for creating custom Shoes widgets.
  #
  # To use, inherit from {Shoes::Widget} and implement a initialize_widget
  # method. You get a few magical effects:
  #
  # * When you inherit from {Shoes::Widget}, you get a method in your Apps to
  #   create your widgets. The method is lower- and snake-cased. It returns
  #   an instance of your widget class.
  #
  # * Your widgets delegate missing methods to their app object. This
  #   allows you to use the Shoes DSL within your widgets.
  #
  # * Your widget otherwise behaves like a flow. If the final parameter to
  #   the widget method is a Hash, that will initialize the flow as well.
  #
  # @example
  #   class SayHello < Shoes::Widget
  #     def initialize_widget word
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

    # Having Widget define initialize makes it easier for us to detect whether
    # subclasses have inappropriately overridden it or not.
    def initialize(*_)
      super
    end

    def initialize_widget
      # Expected to be overridden by children but not guaranteed
    end

    def shoes_base_class
      Shoes::Widget
    end

    def self.inherited(klass, &_blk)
      # Ensure Hover styling class exists, but Widget gets hover behavior from parents
      Shoes::Common::Hover.create_hover_class(klass)

      dsl_method = dsl_method_name(klass)
      Shoes::App.new_dsl_method(dsl_method) do |*args|
        # Old-school widgets that try to use initialize instead of
        # initialize_widget will get a warning before they likely fail on new.
        klass.warn_about_initialize

        # If last arg is a Hash, pass that to the underlying Flow
        container_args = args.last.is_a?(Hash) ? args.last : {}

        # Expected to call through to initialize our underlying slot behavior
        widget_instance = klass.new(@__app__, @__app__.current_slot, container_args)

        # Call the user's widget initialization, with proper slot context
        old_current_slot = @__app__.current_slot
        @__app__.current_slot = widget_instance
        widget_instance.initialize_widget(*args)
        @__app__.current_slot = old_current_slot

        widget_instance
      end
    end

    def self.dsl_method_name(klass)
      klass.to_s[/(^|::)(\w+)$/, 2]
           .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
           .gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end

    def self.warn_about_initialize
      if instance_method(:initialize).owner != Shoes::Widget
        Shoes.logger.warn <<~EOS
          You've defined an `initialize` method on class '#{self}'. This is no longer supported.
                Your widget likely won't display, and you'll potentially receive argument errors.

                Instead, define `initialize_widget` and we'll call it from your generated widget method.
        EOS
      end
    end
  end
end
