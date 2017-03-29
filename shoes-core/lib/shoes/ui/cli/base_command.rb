# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class BaseCommand
        attr_reader :args

        def initialize(args)
          @args = args
        end

        def warn_on_unexpected_parameters
          return unless args.size > 1

          unexpected = args[1..-1].join(" ")
          Shoes.logger.warn("Unexpected extra parameters '#{unexpected}'")
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
