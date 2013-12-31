require 'shoes/spec_helper'

describe Shoes::ListBox do
  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  let(:input_block) { ->(listbox) {} }
  let(:input_opts)  { { items: ["Wine", "Vodka", "Water"], left: left, top: top, width: width, height: height } }
  let(:app)         { Shoes::App.new }
  let(:parent)      { Shoes::Flow.new app, app}

  subject           { Shoes::ListBox.new(app, parent, input_opts, input_block) }

  it_behaves_like "an element that can respond to change"
  it_behaves_like "object with state"
  it_behaves_like "object with dimensions"

  describe "relative dimensions from parent" do
    subject { Shoes::ListBox.new(app, parent, relative_opts, input_block) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject { Shoes::ListBox.new(app, parent, negative_opts, input_block) }
    it_behaves_like "object with negative dimensions"
  end

  it "should contain the correct items" do
    subject.items.should eq ["Wine", "Vodka", "Water"]
  end

  it "should allow us to change the items" do
    lb = subject
    lb.items = ["Pie", "Apple", "Pig"]
    lb.items.should eq ["Pie", "Apple", "Pig"]
  end

  describe 'Choosing' do
    it "should allow us to choose an option" do
      subject.should respond_to :choose
    end

    def expect_gui_choose_with(string)
      expect_any_instance_of(Shoes.configuration.backend::ListBox).
      to receive(:choose).with string
    end

    it "should call @gui.choose when we choose something" do
      expect_gui_choose_with "Wine"
      subject.choose "Wine"
    end

    it 'should call @gui.choose when the choose option is passed' do
      expect_gui_choose_with 'Wine'
      Shoes::ListBox.new app, parent, input_opts.merge(choose: 'Wine')
    end
  end

  it "should delegate #text to the backend" do
    Shoes.configuration.backend::ListBox.any_instance.
        should_receive(:text).and_return("Sneakers & Sandals")
    subject.text.should == "Sneakers & Sandals"
  end
end
