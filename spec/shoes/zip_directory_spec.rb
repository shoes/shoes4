require 'spec_helper'
require 'support/shared_zip'
require 'fileutils'
require 'shoes/package/zip_directory'

describe Shoes::Package::ZipDirectory do
  subject { Shoes::Package::ZipDirectory.new input_dir, output_file }

  context "output file" do
    include_context 'zip'

    it "exists" do
      output_file.should exist
    end

    it "includes input directory without parents" do
      zip.entries.map(&:name).should include(add_trailing_slash input_dir.basename)
    end

    relative_input_paths(input_dir.parent).each do |path|
      it "includes all children of input directory" do
        zip.entries.map(&:name).should include(path)
      end
    end

    it "doesn't include extra files" do
      number_of_files = Dir.glob("#{input_dir}/**/*").push(input_dir).length
      zip.entries.length.should eq(number_of_files)
    end
  end
end
