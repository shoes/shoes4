require 'swt_shoes/spec_helper'

describe Shoes::Swt::EditBox do
  let(:container) { real }
  let(:gui)    { double("gui", real: real, clickable_elements: [], add_clickable_element: nil) }
  let(:app)    { double("app", gui: gui) }
  let(:real)   { double('real', is_disposed?: false, disposed?: false).as_null_object }
  let(:parent) { double("parent", gui: gui, real: real, app: app) }
  let(:dsl)    { double('dsl', app: app, visible?: true,
                        left: 100, top: 100,
                        width: 70, height: 10,
                        initial_text: 'jay', secret?: false ) }

  subject { Shoes::Swt::EditBox.new dsl, parent }

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
end
