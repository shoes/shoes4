require 'shoes/spec_helper'

describe Shoes::BuiltinMethods do
  let(:input_blk) { Proc.new {} }
  let(:app) { Shoes::App.new({}, &input_blk) }

  subject { Shoes::BuiltinMethods }

  after :each do
    Shoes::LOG.clear
  end

  describe 'Shoes.p' do
    it 'adds a debug to the log with an inspected object' do
      Shoes.p 'message'
      Shoes::LOG.should include ['debug', 'message'.inspect]
    end

    it 'also handles object the way they should be handled' do
      Shoes.p []
      Shoes::LOG.should include ['debug', '[]']
    end
  end

  describe "at start of Shoes app" do
    it "should clear Shoes::LOG" do
      Shoes::LOG.should == []
    end
  end

  describe "info" do
    it "sets Shoes::LOG" do
      Shoes.app.info("test")
      Shoes::LOG.should == [["info", "test"]]
    end
  end

  describe "debug" do
    it "sets Shoes::LOG" do
      Shoes.app.debug("test")
      Shoes::LOG.should == [["debug", "test"]]
    end
  end

  describe "warn" do
    it "sets Shoes::LOG" do
      Shoes.app.warn("test")
      Shoes::LOG.should == [["warn", "test"]]
    end
  end

  describe "error" do
    it "sets Shoes::LOG" do
      Shoes.app.error("test")
      Shoes::LOG.should == [["error", "test"]]
    end
  end
end
