require 'shoes/package/recursive_zip'

module Shoes
  module Package
    class ZipDirectory
      # @param [#to_s] input_dir the directory to zip
      # @param [#to_s] output_file the location of the output archive
      def initialize(input_dir, output_file)
        @input_dir = Pathname.new(input_dir)
        @zip = RecursiveZip.new(output_file)
      end
      
      # Zip the whole input directory, including the root
      def write
        @zip.write [@input_dir.basename], @input_dir.parent, ''
      end
    end
  end
end
