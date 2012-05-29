require 'delegate'

module Shoes
  module Logger
    class Log4j < SimpleDelegator
      def initialize
        require 'java'
        require 'support/log4j-1.2.16.jar'
        require 'log4jruby'

        super(Log4jruby::Logger.get('test', :tracing => true, :level => :debug))
      end
    end
  end
end

Shoes::Logger.register(:log4j, Shoes::Logger::Log4j)
