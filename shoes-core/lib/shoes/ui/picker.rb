# frozen_string_literal: true

#
# This class is used for interactively (if necessary) picking the Shoes
# backend that the user will run their Shoes app with.
#
# This interacts with backend gems via the following contract:
#
#   * Backend provides file "shoes/#{backend_name}/generate_backend.rb"
#   * Requiring that file defines a module Shoes::SelectedBackend
#   * Shoes::SelectedBackend should implement the following class methods:
#     * generate(path) - passed bin path, generates shell command to start
#                        Shoes on given backend
#     * validate() - checks whether this backend is valid to run (i.e. right
#                    ruby platform) and exits if not.
#
class Shoes
  module UI
    class Picker
      def initialize(input = STDIN, output = STDOUT)
        @input  = input
        @output = output
      end

      def run(bin_dir, desired_backend = nil)
        bundle

        require_generator(desired_backend)
        validate_generator

        write_backend(bin_dir)
      end

      # Only bundle if we find a local Gemfile.  This allows us to work properly
      # running from source without finding gem-installed backends.
      def bundle
        return unless File.exist?("Gemfile")

        # Only need bundler/setup to get our paths right--we don't need to
        # actually require the gems, since we find the generate_backend.rb's
        # and just require them directly.
        require 'bundler/setup'
      end

      def select_generator(desired_backend = nil)
        candidates = find_candidates(desired_backend)

        if candidates.empty?
          raise ArgumentError, "No gems found matching '#{desired_backend}'"
        elsif candidates.one?
          candidate = candidates.first
          @output.puts "Selecting #{name_for_candidate(candidate)} backend to use. This is a one-time operation."
          candidate
        else
          candidates.sort!
          output_candidates(candidates)
          prompt_for_candidate(candidates)
        end
      end

      def find_candidates(desired_backend)
        search_string = "shoes/**/#{desired_backend}/generate_backend.rb"
        search_string = search_string.gsub("//", "/")
        Gem.find_files(search_string)
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
          if entered_index.positive?
            candidate = candidates[entered_index - 1]
            break if candidate
          end
          @output.puts "Invalid selection. Try again with a number from 1 to #{candidates.size}."
        end

        candidate
      end

      def name_for_candidate(candidate)
        match = %r{.*lib\/shoes\/(.*)\/generate_backend.rb}.match(candidate)[1]
        "shoes-#{match.tr('/', '-')}"
      end

      def require_generator(desired_backend)
        generator_file = select_generator(desired_backend)
        require generator_file
      end

      def validate_generator
        Shoes::SelectedBackend.validate
      end

      def write_backend(bin_dir)
        File.open(File.expand_path(File.join(bin_dir, "shoes-backend")), "w") do |file|
          dest_dir = ENV["SHOES_PICKER_BIN_DIR"] || bin_dir
          file.write(Shoes::SelectedBackend.generate(dest_dir))
        end
      end
    end
  end
end
