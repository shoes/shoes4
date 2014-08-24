require 'shoes/spec_helper'

describe Shoes::ListBox do
  include_context "dsl app"
  let(:input_opts)  { { items: ["Wine", "Vodka", "Water"], left: left, top: top, width: width, height: height } }

  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  subject(:list_box) { Shoes::ListBox.new(app, parent, input_opts, input_block) }

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

  it "contains the correct items" do
    p subject.style.to_s
    p subject.items
    expect(subject.items).to eq(["Wine", "Vodka", "Water"])
  end

  it "changes the items" do
    list_box.items = ["Pie", "Apple", "Pig"]
    expect(list_box.items).to eq(["Pie", "Apple", "Pig"])
  end

  describe 'Choosing' do
    it "allows us to choose an option" do
      expect(list_box).to respond_to(:choose)
    end

    def expect_gui_choose_with(string)
      expect_any_instance_of(Shoes.configuration.backend::ListBox).
      to receive(:choose).with string
    end

    it "should call @gui.choose when we choose something" do
      expect_gui_choose_with "Wine"
      list_box.choose "Wine"
    end
    
  end

  it "should delegate #text to the backend" do
    expect_any_instance_of(Shoes.configuration.backend::ListBox).
        to receive(:text).and_return("Sneakers & Sandals")
    expect(list_box.text).to eq("Sneakers & Sandals")
  end
end
