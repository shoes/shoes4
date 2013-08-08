require 'shoes/spec_helper'

describe Shoes::BuiltinMethods do
  let(:input_blk) { Proc.new {} }
  let(:app) { Shoes::App.new({}, &input_blk) }

  subject { Shoes::BuiltinMethods }

  context "at start of Shoes app" do
    it "should clear Shoes::LOG" do
      Shoes::LOG.should == []
    end
  end

  context "info" do
    it "sets Shoes::LOG" do
    end
  end

  context "debug" do
    it "sets Shoes::LOG" do
    end
  end

  context "warn" do
    it "sets Shoes::LOG" do
    end
  end

  context "error" do
    it "sets Shoes::LOG" do
    end
  end
end
