require 'shoes/spec_helper'

describe Shoes::ListBox do
  subject           { Shoes::ListBox.new(app, parent, input_opts, input_block) }
  let(:input_block) { ->(listbox) {} }
  let(:input_opts)  { { :items => ["Wine", "Vodka", "Water"] } }
  let(:app)         { Shoes::App.new }
  let(:parent)      { Shoes::Flow.new app, app: app}

  it_behaves_like "an element that can respond to change"

  it "should contain the correct items" do
    subject.items.should eq ["Wine", "Vodka", "Water"]
  end

  it "should allow us to change the items" do
    lb = subject
    lb.items = ["Pie", "Apple", "Pig"]
    lb.items.should eq ["Pie", "Apple", "Pig"]
  end

  it "should allow us to choose an option" do
    subject.should respond_to :choose
  end

  it "should call @gui.choose when we choose something" do
    Shoes.configuration.backend::ListBox.any_instance.
        should_receive(:choose).with "Wine"
    subject.choose "Wine"
  end

  it "should delegate #text to the backend" do
    Shoes.configuration.backend::ListBox.any_instance.
        should_receive(:text).and_return("Sneakers & Sandals")
    subject.text.should == "Sneakers & Sandals"
  end
end
