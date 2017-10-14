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

        def help
          <<-EOS
shoes select_backend [backend]
    Select a Shoes backend to use. A backend can be specified, or Shoes will
    attempt to auto-detect available backends to select from.
EOS
        end
      end
    end
  end
end
