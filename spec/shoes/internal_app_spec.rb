require 'shoes/spec_helper'

describe Shoes::InternalApp do
  let(:user_facing_app) { instance_double("Shoes::App") }
  subject { Shoes::InternalApp.new user_facing_app, opts }

  describe "#initialize" do
    context "with defaults" do
      let(:opts) { Hash.new }
      let(:defaults) { Shoes::InternalApp::DEFAULT_OPTIONS }

      it "sets title", :qt do
        expect(subject.app_title).to eq defaults[:title]
      end

      it "is resizable", :qt do
        expect(subject.resizable).to be_truthy
      end

      it "sets width" do
        expect(subject.width).to eq(defaults[:width])
      end

      it "sets height" do
        expect(subject.height).to eq(defaults[:height])
      end

      it "does not start as fullscreen" do
        expect(subject.start_as_fullscreen?).to be_falsey
      end
    end

    context "with custom opts" do
      let(:opts) { {:width => 150, :height => 2, :title => "Shoes::App Spec", :resizable => false, :fullscreen => true} }

      it "sets title", :qt do
        expect(subject.app_title).to eq opts[:title]
      end

      it "sets resizable", :qt do
        expect(subject.resizable).to be_falsey
      end

      it "sets width" do
        expect(subject.width).to eq(opts[:width])
      end

      it "sets height" do
        expect(subject.height).to eq(opts[:height])
      end

      it "sets fullscreen" do
        expect(subject.start_as_fullscreen?).to be_truthy
      end
    end
  end

  describe '#add_child' do
    let(:child) { double 'child' }
    let(:opts) { Hash.new }

    it 'adds the child to the top_slot when there is one' do
      top_slot = instance_double("Shoes::Flow")
      allow(subject).to receive(:top_slot) { top_slot }
      expect(subject.top_slot).to receive(:add_child).with(child)
      subject.add_child child
    end

    it 'adds the child to its own contents when there is no top_slot' do
      subject.add_child child
      expect(subject.contents).to include child
    end
  end
end
