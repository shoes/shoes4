module Shoes
  module Logger
    class << self
      def register(name, obj)
        @loggers ||= { }
        @loggers[name] = obj
      end

      def unregister(name)
        @loggers.delete(name)
      end

      def get(name)
        @loggers && @loggers[name]
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), "logger", "*.rb")].each { |logger|
  require logger
}
