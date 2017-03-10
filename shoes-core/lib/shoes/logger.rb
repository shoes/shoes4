# frozen_string_literal: true
require 'logger'

class Shoes
  class Logger
    def initialize
      @loggers = []
    end

    def <<(logger)
      @loggers << logger
      self
    end

    def debug(message)
      forward(:debug, message)
    end

    def info(message)
      forward(:info, message)
    end

    def warn(message)
      forward(:warn, message)
    end

    def error(message)
      forward(:error, message)
    end

    def forward(meth, message)
      @loggers.each do |logger|
        logger.public_send(meth, message)
      end
    end

    class StandardLogger < SimpleDelegator
      def initialize(device = STDERR)
        logger = ::Logger.new(device)
        logger.formatter = proc do |severity, _datetime, _progname, message|
          "#{severity}: #{message}\n"
        end
        super(logger)
      end
    end
  end
end
