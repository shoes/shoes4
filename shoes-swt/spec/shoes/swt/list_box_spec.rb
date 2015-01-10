require 'shoes/swt/spec_helper'

describe Shoes::Swt::ListBox do
  include_context "swt app"

  let(:items)  { ["Pie", "Apple", "Sand"] }
  let(:dsl)    { double('dsl', app: shoes_app,
                        items: items, opts: {},
                        element_width: 200, element_height: 20).as_null_object }
  let(:block)  { ->(){} }
  let(:real)   { double('real', text: "", :items= => true,
                        set_size: true, add_selection_listener: true,
                        disposed?: false ) }

  subject { Shoes::Swt::ListBox.new dsl, parent, &block }

  before :each do
    allow(parent).to receive(:real)
    allow(::Swt::Widgets::Combo).to receive(:new) { real }
  end

  it_behaves_like "updating visibility"

  it "should return nil when nothing is highlighted" do
    expect(subject.text).to be_nil
  end

  it "should call 'items' when updating values" do
    allow(dsl).to receive(:items).and_return ["hello"]
    subject.update_items
    # creation already calls update_items once
    expect(real).to have_received(:items=).with(["hello"]).twice
  end

  it "should respond to choose" do
    expect(subject).to respond_to :choose
  end

  it "should call text= when choosing" do
    expect(real).to receive(:text=).with "Bacon"
    subject.choose "Bacon"
  end

  it 'sets the items on real upon initialization' do
    subject
    expect(real).to have_received(:items=).with(items)
  end

  it 'converts array to string' do
    allow(dsl).to receive(:items).and_return [1,2,3]
    subject.update_items
    # creation already calls update_items once
    expect(real).to have_received(:items=).with(%w(1 2 3)).twice
  end

  describe "when the backend notifies us that the selection has changed" do
    it "should call the change listeners" do
      expect(dsl).to receive(:call_change_listeners)
      expect(real).to receive(:add_selection_listener) do |&blk|
        blk.call()
      end
      subject
    end
  end
end
