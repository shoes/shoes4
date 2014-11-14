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
  class Widget
    include Common::Inspect

    Shoes::App.subscribe_to_dsl_methods self

    attr_accessor :parent
    attr_writer :app

    class << self
      attr_accessor :app
    end

    # lookup a bit more complicated as during initialize we do
    # not have @app yet...
    def app
      @app || self.class.app
    end

    def self.inherited(klass, &_blk)
      dsl_method = dsl_method_name(klass)
      Shoes::App.new_dsl_method(dsl_method) do |*args, &blk|
        # we set app 2 times because widgets execute most of their code
        # straight in initialize. I dunno if there is a good way of setting
        # an @app instance variable before initialize is executed. We could
        # hand it over in #initialize but that would break the interface
        # and people would have to set it themselves or make sure to call
        # super so for not it's like this.
        # Setting the ref on the instance is important as we might have
        # instances of the same widget in different Shoes::Apps so each one
        # needs to save the reference to the one it was started with
        klass.app              = self
        widget_instance        = klass.new(*args, &blk)
        widget_instance.app    = self
        widget_instance.parent = @__app__.current_slot
        widget_instance
      end
    end

    private

    def self.dsl_method_name(klass)
      klass.to_s[/(^|::)(\w+)$/, 2]
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end
  end
end
