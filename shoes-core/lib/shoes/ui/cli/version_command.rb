# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class VersionCommand < BaseCommand
        def run
          puts "Shoes #{Shoes::Core::VERSION}"
        end

        def help
          <<-EOS
shoes version
    Prints the current Shoes version
EOS
        end
      end
    end
  end
end
