# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class PackageCommand < BaseCommand
        def run
          @packager = Shoes::Packager.new
          @packager.parse!(args)

          path = args[1]
          @packager.run(path)
        end
      end
    end
  end
end
