require 'shoes/package/recursive_zip'

module Shoes
  module Package
    class ZipDirectoryContents
      # @param [#to_s] input_dir the directory to zip
      # @param [#to_s] output_file the location of the output archive
      def initialize(input_dir, output_file)
        @input_dir = Pathname.new(input_dir)
        @zip = RecursiveZip.new(output_file)
      end
      
      # Zip the contents of the input directory, without the root.
      def write
        entries = @input_dir.children(false)
        @zip.write entries, @input_dir, ''
      end
    end
  end
end
