# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class HelpCommand < BaseCommand
        def run
          warn_on_unexpected_parameters

          puts "Shoes is the best little GUI toolkit for Ruby."
          puts

          command_classes = [DefaultCommand]
          command_classes.concat(SUPPORTED_COMMANDS.map(&:last))

          command_classes.each do |command_class|
            text = command_class.help.to_s
            unless text.empty?
              puts text
              puts
            end
          end
        end

        def self.help
          <<-EOS
shoes help
    Displays this help text
EOS
        end
      end
    end
  end
end
