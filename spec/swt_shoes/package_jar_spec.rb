require 'spec_helper'
require 'pathname'
require 'shoes/swt/package/jar'

include PackageHelpers

describe Shoes::Swt::Package::Jar do
  include_context 'config'
  include_context 'package'

  context "when creating a .jar" do
    before :all do
      output_dir.rmtree if output_dir.exist?
      output_dir.mkpath
      Dir.chdir app_dir do
        @jar_path = subject.package(output_dir)
      end
    end

    let(:jar_name) { 'sweet-nebulae.jar' }
    let(:output_file) { Pathname.new(output_dir.join jar_name) }
    let(:config) { Shoes::Package::Configuration.load(config_filename) }
    subject { Shoes::Swt::Package::Jar.new(config) }

    it "creates a .jar" do
      output_file.should exist
    end

    it "returns path to .jar" do
      @jar_path.should eq(output_file.to_s)
    end

    it "creates .jar smaller than 50MB" do
      File.size(output_file).should be < 50 * 1024 * 1024
    end

    it "excludes directories recursively" do
      jar = Zip::ZipFile.new(output_file)
      jar.entries.should_not include("dir_to_ignore/file_to_ignore")
    end

    its(:default_dir) { should eq(output_dir) }
    its(:filename) { should eq(jar_name) }
  end
end
