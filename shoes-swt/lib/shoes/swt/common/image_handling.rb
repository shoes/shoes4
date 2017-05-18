# frozen_string_literal: true
class Shoes
  module Swt
    module Common
      module ImageHandling
        # Why copy the file to a temporary location just to pass a different name
        # to load? Because SWT doesn't like us when we're packaged!
        #
        # Apparently the warbler-style path names we end up with for relative
        # image paths don't cross nicely to SWT, so we need to resolve the paths
        # in Ruby-land before handing it over.
        def load_file_image_data(name)
          tmpname = File.join(Dir.tmpdir, "__shoes4_#{Time.now.to_i}_#{File.basename(name)}")
          FileUtils.cp(name, tmpname)

          @cleanup_files ||= []
          @cleanup_files << tmpname
          tmpname
        end

        def cleanup_temporary_files
          return unless @cleanup_files

          @cleanup_files.each do |file|
            begin
              FileUtils.rm(file)
            rescue => e
              Shoes.logger.debug("Error during image temp file cleanup.\n#{e.class}: #{e.message}")
            end
          end
          @cleanup_files.clear
        end
      end
    end
  end
end
