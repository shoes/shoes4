# frozen_string_literal: true

class Shoes
  module Common
    module ImageHandling
      def absolute_file_path(path)
        if Pathname(path).absolute?
          search_for(File.basename(path), File.dirname(path))
        else
          search_for(path, *default_search_paths)
        end
      end

      def search_for(path, *locations)
        found = locations.map { |dir| File.join(dir, path) }
                         .find { |candidate| File.exist?(candidate) }

        unless found
          raise FileNotFoundError, "#{path} not found. Searched #{locations.join(',')}"
        end

        found
      end

      def default_search_paths
        [Dir.pwd, Shoes.configuration.app_dir, File.join(Shoes::DIR, "static")]
      end
    end
  end
end
