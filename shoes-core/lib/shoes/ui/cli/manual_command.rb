# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class ManualCommand < BaseCommand
        def run
          require 'shoes/manual'
          Shoes::Manual.run "English"
        end
      end
    end
  end
end
