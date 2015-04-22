class Shoes
  module UI
    # This class is used for interactively (if necessary) picking the Shoes
    # backend that the user will run their Shoes app with.
    class Picker
      def initialize(input=STDIN, output=STDOUT)
        @input  = input
        @output = output
      end

      def run(bin_dir)
        bundle
        generator_file = select_generator
        write_backend(generator_file, bin_dir)
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
        candidates = Gem.find_files("shoes/**/generate-backend.rb")
        if candidates.one?
          candidate = candidates.first
          @output.puts "Selecting #{name_for_candidate(candidate)} backend to use. This is a one-time operation."
          candidate
        else
          candidates.sort!
          output_candidates(candidates)
          prompt_for_candidate(candidates)
        end
      end

      def output_candidates(candidates)
        @output.puts
        @output.puts "Enter a number to select a Shoes backend (This is a one-time operation):"

        candidates.each_with_index do |candidate, index|
          @output.puts " #{index + 1}. #{name_for_candidate(candidate)}"
        end

        @output.print "> "
      end

      def prompt_for_candidate(candidates)
        candidate = nil

        until candidate
          entered_index = @input.readline.to_i
          if entered_index > 0
            if candidate = candidates[entered_index - 1]
              break
            end
          end
          @output.puts "Invalid selection. Try again with a number from 1 to #{candidates.size}."
        end

        candidate
      end

      def name_for_candidate(candidate)
        /.*lib\/shoes\/(.*)\/generate-backend.rb/.match(candidate)
        return "shoes-#{$1.gsub("/", "-")}"
      end

      def write_backend(generator_file, bin_dir)
        require generator_file

        File.open(File.expand_path(File.join(bin_dir, "shoes-backend")), "w") do |file|
          # Contract with backends is to define generate_backend method that we
          # can call. Bit ugly, open to better options for that interchange.
          file.write(generate_backend(ENV["SHOES_PICKER_BIN_DIR"] || bin_dir))
        end
      end
    end
  end
end
