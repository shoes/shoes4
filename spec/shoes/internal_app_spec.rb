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
    end

    context "with custom opts" do
      let(:opts) { {:width => 150, :height => 2, :title => "Shoes::App Spec", :resizable => false} }

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
    end
  end
end
