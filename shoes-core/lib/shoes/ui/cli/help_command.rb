# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class HelpCommand < BaseCommand
        def run
          puts "halp!"
        end
      end
    end
  end
end
