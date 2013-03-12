module Shoes
  class Widget
    def self.inherited klass, &blk
      m = klass.to_s[/(^|::)(\w+)$/, 2].
              gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
              gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
      Shoes::App.class_eval do
        define_method m do |*args, &blk|
          klass.send :class_variable_set, :@@__app__, self
          parent = current_slot
          klass.new(*args, &blk).tap do |s|
            s.define_singleton_method(:parent){parent}
          end
        end
      end
      klass.class_eval do
        define_method :method_missing do |*args, &blk|
          klass.send(:class_variable_get, :@@__app__).send *args, &blk
        end
      end
    end
  end
end
