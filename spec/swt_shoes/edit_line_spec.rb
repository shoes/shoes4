require 'swt_shoes/spec_helper'

describe Shoes::Swt::EditLine do
  let(:container) { real }
  let(:gui)    { double("gui", real: real) }
  let(:app)    { double("app", gui: gui) }
  let(:dsl) { double('dsl', app: app,
                     visible?: true,
                     element_width: 80, element_height: 22,
                     initial_text: 'YOLO',
                     secret?: true).as_null_object }
  let(:parent) { double('parent') }
  let(:real) { double('real', is_disposed?: false, disposed?: false).as_null_object }

  subject { Shoes::Swt::EditLine.new dsl, parent }

  before :each do
    parent.stub(:real)
    ::Swt::Widgets::Text.stub(:new) { real }
    ::Swt::Widgets::Text.stub(:text=) { real }
  end

  it_behaves_like "movable element"
  it_behaves_like "clearable native element"
  it_behaves_like "togglable"

  describe "#initialize" do
    it "sets text on real element" do
      real.should_receive(:text=).with("some text")
      subject.text = "some text"
    end

    it "should set up a listener that delegates change events" do
      dsl.should_receive(:call_change_listeners)
      real.should_receive(:add_modify_listener) do |&blk|
        blk.call()
      end
      subject
    end
  end

  describe "responding to change" do
  end

  describe ":secret option" do
    it "sets PASSWORD style" do
      subject.real.getStyle & (::Swt::SWT::SINGLE | ::Swt::SWT::BORDER | ::Swt::SWT::PASSWORD) == ::Swt::SWT::SINGLE | ::Swt::SWT::BORDER | ::Swt::SWT::PASSWORD
    end
  end
end
