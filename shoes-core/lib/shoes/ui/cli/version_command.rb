# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class VersionCommand < BaseCommand
        def run
          puts "Shoes #{Shoes::Core::VERSION}"
        end
      end
    end
  end
end
