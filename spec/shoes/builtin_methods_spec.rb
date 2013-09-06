require 'shoes/spec_helper'

describe Shoes::BuiltinMethods do
  let(:input_blk) { Proc.new {} }
  let(:app) { Shoes::App.new({}, &input_blk) }

  subject { Shoes::BuiltinMethods }

  before :each do
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

  describe "info" do
    it "sets Shoes::LOG" do
      app.info("test")
      Shoes::LOG.should == [["info", "test"]]
    end
  end

  describe "debug" do
    it "sets Shoes::LOG" do
      app.debug("test")
      Shoes::LOG.should == [["debug", "test"]]
    end
  end

  describe "warn" do
    it "sets Shoes::LOG" do
      app.warn("test")
      Shoes::LOG.should == [["warn", "test"]]
    end
  end

  describe "error" do
    it "sets Shoes::LOG" do
      app.error("test")
      Shoes::LOG.should == [["error", "test"]]
    end
  end
end
