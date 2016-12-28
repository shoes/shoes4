require 'spec_helper'
require 'shoes/ui/picker'

describe Shoes::UI::Picker do
  let(:swt_backend)  { "/gems/lib/shoes/swt/generate_backend.rb" }
  let(:faux_backend) { "/gems/lib/shoes/faux/generate_backend.rb" }

  let(:generate_backend_file) do
    return nil if Shoes.configuration.backend_name == :mock
    "shoes/#{Shoes.configuration.backend_name}/generate_backend.rb"
  end

  let(:output) { StringIO.new }
  let(:input)  { StringIO.new }

  subject { Shoes::UI::Picker.new(input, output) }

  it "selects single backend generator" do
    allow(Gem).to receive(:find_files) { [swt_backend] }
    expect(subject.select_generator).to eq(swt_backend)
  end

  describe "with multiple backend generators" do
    before do
      allow(Gem).to receive(:find_files) { [faux_backend, swt_backend] }
    end

    it "prompts with multiple backend generators" do
      select("1")
      subject.select_generator

      output.rewind
      result = output.read

      expect(result).to include("shoes-faux")
      expect(result).to include("shoes-swt")
    end

    it "selects from multiple backend generators" do
      select("2")
      expect(subject.select_generator).to eq(swt_backend)
    end

    it "retries for index past bounds" do
      select("3\n1")
      expect(subject.select_generator).to eq(faux_backend)
    end

    it "retries for index before bounds" do
      select("0\n1")
      expect(subject.select_generator).to eq(faux_backend)
    end

    it "retries for junk" do
      select("junk\n1")
      expect(subject.select_generator).to eq(faux_backend)
    end

    it "fails if no matches" do
      allow(Gem).to receive(:find_files) { [] }
      expect { subject.select_generator }.to raise_error(ArgumentError)
    end

    it "selects by name" do
      allow(Gem).to receive(:find_files) { [swt_backend] }
      expect(subject.select_generator("swt")).to eq(swt_backend)
    end

    it "loads a compatible class from generator" do
      # Don't bother with mock backend
      if generate_backend_file
        expect { Shoes::SelectedBackend }.to raise_error(NameError)

        load generate_backend_file

        expect(Shoes::SelectedBackend).to respond_to(:generate)
      end
    end

    def select(typed_input)
      input.write(typed_input)
      input.rewind
    end
  end
end
