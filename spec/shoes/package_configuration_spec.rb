require 'spec_helper'
require 'shoes/package/configuration'

describe Shoes::Package::Configuration do
  context "defaults" do
    subject { Shoes::Package::Configuration.new }

    its(:name) { should eq('Shoes App') }
    its(:shortname) { should eq('shoesapp') }
    its(:ignore) { should eq(['pkg']) }
    its(:gems) { should include('shoes') }
    its(:version) { should eq('0.0.0') }
    its(:release) { should eq('Rookie') }
    its(:icons) { should be_an_instance_of(Hash) }
    its(:dmg) { should be_an_instance_of(Hash) }
    its(:run) { should be_nil }
    it { should_not be_valid }

    describe "#icon" do
      it 'osx is nil' do
        subject.icons[:osx].should be_nil
      end

      it 'gtk is nil' do
        subject.icons[:gtk].should be_nil
      end

      it 'win32 is nil' do
        subject.icons[:win32].should be_nil
      end
    end

    describe "#dmg" do
      it "has ds_store" do
        subject.dmg[:ds_store].should eq('path/to/default/.DS_Store')
      end

      it "has background" do
        subject.dmg[:background].should eq('path/to/default/background.png')
      end
    end

    describe "#to_hash" do
      it "round-trips" do
        Shoes::Package::Configuration.new(subject.to_hash).should eq(subject)
      end
    end
  end

  context "with options" do
    include_context 'config'
    let(:standard_config) { Shoes::Package::Configuration.load(config_filename) }
    subject { standard_config }

    its(:name) { should eq('Sugar Clouds') }
    its(:shortname) { should eq('sweet-nebulae') }
    its(:ignore) { should include('pkg') }
    its(:gems) { should include('rspec') }
    its(:gems) { should include('shoes') }
    its(:version) { should eq('0.0.1') }
    its(:release) { should eq('Mindfully') }
    its(:run) { should eq('bin/hello_world') }
    its(:icons) { should be_an_instance_of(Hash) }
    its(:dmg) { should be_an_instance_of(Hash) }
    it { should be_valid }

    describe "#icon" do
      it 'has osx' do
        subject.icons[:osx].should eq('img/boots.icns')
      end

      it 'has gtk' do
        subject.icons[:gtk].should eq('img/boots_512x512x32.png')
      end

      it 'has win32' do
        subject.icons[:win32].should eq('img/boots.ico')
      end
    end

    describe "#dmg" do
      it "has ds_store" do
        subject.dmg[:ds_store].should eq('path/to/custom/.DS_Store')
      end

      it "has background" do
        subject.dmg[:background].should eq('path/to/custom/background.png')
      end
    end

    it "incorporates custom features" do
      subject.custom.should eq('my custom feature')
    end

    context "including name, but without explicit shortname" do
      let(:options) { standard_config.to_hash.merge({:name => "Sugar Clouds", :shortname => nil}) }
      subject { Shoes::Package::Configuration.new options, standard_config.working_dir }

      its(:name) { should eq("Sugar Clouds") }
      its(:shortname) { should eq("sugarclouds") }
      it { should be_valid }
    end

    context "when the file to run doens't exist" do
      let(:options) { standard_config.to_hash.merge({:run => "path/to/non-existent/file"}) }
      subject { Shoes::Package::Configuration.new options, standard_config.working_dir }

      it { should_not be_valid }
    end

    context "when the osx icon doesn't exist" do
      let(:standard_icons) { standard_config.to_hash[:icons] }
      let(:icons) { standard_icons.merge({:osx => "path/to/non-existent/file"}) }
      let(:options) { standard_config.to_hash.merge({:icons => icons}) }
      subject { Shoes::Package::Configuration.new options, standard_config.working_dir }

      it { should_not be_valid }
    end
  end

  context "auto-loading" do
    include_context 'config'

    context "without a path" do
      it "looks for 'app.yaml' in current directory" do
        Dir.chdir config_filename.parent do
          config = Shoes::Package::Configuration.load
          config.shortname.should eq('sweet-nebulae')
        end
      end

      it "blows up if it can't find the file" do
        Dir.chdir File.dirname(__FILE__) do
          lambda { config = Shoes::Package::Configuration.load }.should raise_error
        end
      end
    end

    shared_examples "config with path" do
      it "finds the config" do
        Dir.chdir File.dirname(__FILE__) do
          config = Shoes::Package::Configuration.load(path)
          config.shortname.should eq('sweet-nebulae')
        end
      end
    end

    context "with an 'app.yaml'" do
      let(:path) { config_filename }
      it_behaves_like "config with path"
    end

    context "with a path to a directory containing an 'app.yaml'" do
      let(:path) { config_filename.parent }
      it_behaves_like "config with path"
    end

    context "with a path to a file that is siblings with an 'app.yaml'" do
      let(:path) { config_filename.parent.join('sibling.rb') }
      it_behaves_like "config with path"
    end

    context "with a path that exists, but no 'app.yaml'" do
      let(:path) { config_filename.parent.join('bin/hello_world') }
      subject { Shoes::Package::Configuration.load(path) }

      its(:name) { should eq('hello_world') }
      its(:shortname) { should eq('hello_world') }
    end

    context "when the file doesn't exist" do
      it "blows up" do
        lambda { Shoes::Package::Configuration.load('some/bogus/path') }.should raise_error
      end
    end
  end
end
