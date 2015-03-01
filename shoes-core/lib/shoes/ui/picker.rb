class Shoes
  module UI
    # This class is used for interactively (if necessary) picking the Shoes
    # backend that the user will run their Shoes app with.
    class Picker
      def run
        bundle
        generator_file = select_generator
        write_backend(generator_file)
      end

      # Only bundle if we find a local Gemfile.  This allows us to work properly
      # running from source without finding gem-installed backends.
      def bundle
        return unless File.exists?("Gemfile")

        # Only need bundler/setup to get our paths right--we don't need to
        # actually require the gems, since we find the generate-backend.rb's
        # and just require them directly.
        require 'bundler/setup'
      end

      def select_generator
        puts "Selecting Shoes backend to use. This is a one-time operation."
        candidates = Gem.find_files("shoes/**/generate-backend.rb")
        if candidates.one?
          generator_file = candidates.first
        else
          fail NotImplementedError("Currently can't interactively select a backend. See #929")
        end

        generator_file
      end

      def write_backend(generator_file)
        require generator_file

        # On Windows getting odd paths with trailing double-quote
        bin_dir = ARGV[0].gsub('"', '')

        File.open(File.expand_path(File.join(bin_dir, "shoes-backend")), "w") do |file|
          # Contract with backends is to define generate_backend method that we
          # can call. Bit ugly, open to better options for that interchange.
          file.write(generate_backend(ENV["SHOES_PICKER_BIN_DIR"] || bin_dir))
        end
      end
    end
  end
end
