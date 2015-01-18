require_relative 'spec_helper'
require 'shoes/package/configuration'
require 'shoes/package/jar'

include PackageHelpers

describe Furoshiki::Jar do
  include_context 'config'
  include_context 'package'

  context "when creating a .jar" do
    before :all do
      @output_dir.rmtree if @output_dir.exist?
      @output_dir.mkpath
      config = Shoes::Package::Configuration.load(@config_filename)
      @subject = Shoes::Package::Jar.new(config)
      @jar_path = @subject.package
    end

    let(:jar_name) { 'sweet-nebulae.jar' }
    let(:output_file) { Pathname.new(@output_dir.join jar_name) }
    subject { @subject }

    it "creates a .jar" do
      expect(output_file).to exist
    end

    it "returns path to .jar" do
      expect(@jar_path).to eq(output_file.to_s)
    end

    it "creates .jar smaller than 60MB" do
      expect(File.size(output_file)).to be < 60 * 1024 * 1024
    end

    context "inspecting contents" do
      let (:jar) { Zip::File.new(output_file) }

      it "includes shoes-core" do
        shoes_core = jar.glob "gems/shoes-core*"
        expect(shoes_core.length).to equal(1)
      end

      it "includes shoes-swt" do
        shoes_swt = jar.glob "gems/shoes-swt*"
        expect(shoes_swt.length).to equal(1)
      end

      it "excludes directories recursively" do
        expect(jar.entries).not_to include("dir_to_ignore/file_to_ignore")
      end
    end

    its(:default_dir) { should eq(@output_dir) }
    its(:filename) { should eq(jar_name) }
  end

  describe "with an invalid configuration" do
    let(:config) { Shoes::Package::Configuration.create}
    subject { Shoes::Package::Jar.new(config) }

    it "fails to initialize" do
      expect { subject }.to raise_error(Furoshiki::ConfigurationError)
    end
  end
end
