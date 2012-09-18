require 'shoes/spec_helper'

describe Shoes::TextBlock do
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, {app: app} }
  subject { Shoes::TextBlock.new(parent, "Hello, world!", 99, {}) }

  describe "initialize" do
    it "creates gui object" do
      subject.gui.should_not be_nil
    end
  end
end
