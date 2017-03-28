# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class BaseCommand
        attr_reader :args

        def initialize(args)
          @args = args
        end

        def self.help
          nil
        end

        def self.help_from_options(command, options)
          lines = ["#{command}\n"] + options.summarize
          lines.join("")
        end
      end
    end
  end
end
