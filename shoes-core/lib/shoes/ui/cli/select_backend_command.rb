# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class SelectBackendCommand < BaseCommand
        def run
          require 'shoes/ui/picker'
          backend = args[1]
          Shoes::UI::Picker.new.run(ENV["SHOES_BIN_DIR"], backend)
        end
      end
    end
  end
end
