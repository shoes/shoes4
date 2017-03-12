# frozen_string_literal: true
require 'logger'

class Shoes
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
