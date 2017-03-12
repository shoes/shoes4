# frozen_string_literal: true

class Shoes
  class LoggerCollection
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

    private

    def forward(meth, message)
      @loggers.each do |logger|
        logger.public_send(meth, message)
      end
    end
  end
end
