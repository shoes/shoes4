require_relative 'spec_helper'
require 'shoes/package/configuration'

describe Shoes::Package::Configuration do
  context "defaults" do
    subject { Shoes::Package::Configuration.create }

    its(:name) { should eq('Shoes App') }
    its(:shortname) { should eq('shoesapp') }
    its(:ignore) { should eq(['pkg']) }
    its(:gems) { should include('shoes-core') }
    its(:version) { should eq('0.0.0') }
    its(:release) { should eq('Rookie') }
    its(:icons) { should be_an_instance_of(Hash) }
    its(:dmg) { should be_an_instance_of(Hash) }
    its(:run) { should be_nil }
    its(:working_dir) { should eq(Pathname.new(Dir.pwd)) }
    it { is_expected.not_to be_valid } # no :run

    # TODO: Implement
    describe "#icons" do
      it 'osx is nil' do
        expect(subject.icons[:osx]).to be_nil
      end

      it 'gtk is nil' do
        expect(subject.icons[:gtk]).to be_nil
      end

      it 'win32 is nil' do
        expect(subject.icons[:win32]).to be_nil
      end
    end

    # TODO: Implement
    describe "#dmg" do
      it "ds_store is nil" do
        expect(subject.dmg[:ds_store]).to be_nil
      end

      it "background is nil" do
        expect(subject.dmg[:background]).to be_nil
      end
    end

    describe "#to_hash" do
      it "round-trips" do
        expect(Shoes::Package::Configuration.create(subject.to_hash)).to eq(subject)
      end
    end
  end

  context "with options" do
    include_context 'config'
    subject { Shoes::Package::Configuration.load(@config_filename) }

    its(:name) { should eq('Sugar Clouds') }
    its(:shortname) { should eq('sweet-nebulae') }
    its(:ignore) { should include('pkg') }
    its(:run) { should eq('bin/hello_world') }
    its(:gems) { should include('rspec') }
    its(:gems) { should include('shoes-core') }
    its(:version) { should eq('0.0.1') }
    its(:release) { should eq('Mindfully') }
    its(:icons) { should be_an_instance_of(Hash) }
    its(:dmg) { should be_an_instance_of(Hash) }
    its(:working_dir) { should eq(@config_filename.dirname) }
    it { is_expected.to be_valid }

    describe "#icons" do
      it 'has osx' do
        expect(subject.icons[:osx]).to eq('img/boots.icns')
      end

      it 'has gtk' do
        expect(subject.icons[:gtk]).to eq('img/boots_512x512x32.png')
      end

      it 'has win32' do
        expect(subject.icons[:win32]).to eq('img/boots.ico')
      end
    end

    describe "#dmg" do
      it "has ds_store" do
        expect(subject.dmg[:ds_store]).to eq('path/to/custom/.DS_Store')
      end

      it "has background" do
        expect(subject.dmg[:background]).to eq('path/to/custom/background.png')
      end
    end

    it "incorporates custom features" do
      expect(subject.custom).to eq('my custom feature')
    end

    it "round-trips" do
      expect(Shoes::Package::Configuration.create(subject.to_hash)).to eq(subject)
    end
  end

  context "with name, but without explicit shortname" do
    let(:options) { {:name => "Sugar Clouds"} }
    subject { Shoes::Package::Configuration.create options }

    its(:name) { should eq("Sugar Clouds") }
    its(:shortname) { should eq("sugarclouds") }
  end

  context "when the file to run doens't exist" do
    let(:options) { {:run => "path/to/non-existent/file"} }
    subject { Shoes::Package::Configuration.create options }

    it { is_expected.not_to be_valid }
  end

  context "when osx icon is not specified" do
    include_context 'config'
    let(:valid_config) { Shoes::Package::Configuration.load(@config_filename) }
    let(:options) { valid_config.to_hash.merge(:icons => {}) }
    subject { Shoes::Package::Configuration.create(options) }

    it "sets osx icon path to nil" do
      expect(subject.icons[:osx]).to be_nil
    end

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when osx icon is specified, but doesn't exist" do
    let(:options) { ({:icons => {:osx => "path/to/non-existent/file"}}) }
    subject { Shoes::Package::Configuration.create options }

    it "sets osx icon path" do
      expect(subject.icons[:osx]).to eq("path/to/non-existent/file")
    end

    it { is_expected.not_to be_valid }
  end

  context "auto-loading" do
    include_context 'config'

    shared_examples "config with path" do
      it "finds the config" do
        Dir.chdir File.dirname(__FILE__) do
          config = Shoes::Package::Configuration.load(path)
          expect(config.shortname).to eq('sweet-nebulae')
        end
      end
    end

    context "with an 'app.yaml'" do
      let(:path) { @config_filename }
      it_behaves_like "config with path"
    end

    context "with a path to a directory containing an 'app.yaml'" do
      let(:path) { @config_filename.parent }
      it_behaves_like "config with path"
    end

    context "with a path to a file that is siblings with an 'app.yaml'" do
      let(:path) { @config_filename.parent.join('sibling.rb') }
      it_behaves_like "config with path"
    end

    context "with a path that exists, but no 'app.yaml'" do
      let(:path) { @config_filename.parent.join('bin/hello_world') }
      subject { Shoes::Package::Configuration.load(path) }

      its(:name) { should eq('hello_world') }
      its(:shortname) { should eq('hello_world') }
    end

    context "when the file doesn't exist" do
      it "blows up" do
        expect { Shoes::Package::Configuration.load('some/bogus/path') }.to raise_error
      end
    end

    context "with additional gems" do
      let(:path) { @config_filename }
      let(:additional_config) { { gems: gems } }
      let(:config) { Shoes::Package::Configuration.load(path, additional_config) }

      context "one gem" do
        let(:gems) { 'shoes-swt' }

        it "adds one additional" do
          expect(config.gems).to include('shoes-swt')
        end
      end

      context "multiple gems" do
        let(:gems) { ['shoes-swt', 'shoes-extras'] }

        it "adds multiple additional gems" do
          expect(config.gems & gems).to eq(gems)
        end
      end
    end
  end
end
