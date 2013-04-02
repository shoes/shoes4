module Shoes
  class Widget
    def self.inherited klass, &blk
      dsl_method = dsl_method_name(klass)
      Shoes::App.class_eval do
        define_method(dsl_method) do |*args, &blk|
          klass.send :class_variable_set, :@@__app__, self
          klass.new(*args, &blk).tap do |s|
            s.define_singleton_method(:parent){current_slot}
          end
        end
      end

      # Delegate missing methods to app, so you can use the Shoes DSL
      # inside the widget.
      klass.class_eval do
        define_method :method_missing do |*args, &blk|
          klass.send(:class_variable_get, :@@__app__).send *args, &blk
        end
      end
    end

    private
    def self.dsl_method_name(klass)
      klass.to_s[/(^|::)(\w+)$/, 2].
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
    end
  end
end
