# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class PackageCommand < BaseCommand
        def run
          @packager = Shoes::Packager.new
          @packager.parse!(args)

          warn_on_unexpected_parameters(2)

          path = args[1]
          @packager.run(path)
        end

        def self.help
          help_from_options("shoes package [options] file",
                            Shoes::Packager.new.options) + <<-EOS

    Packages may be built either from a single .rb file, or a .yaml file with
    more options defined.
EOS
        end
      end
    end
  end
end
