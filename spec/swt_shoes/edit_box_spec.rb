require 'swt_shoes/spec_helper'

describe Shoes::Swt::EditBox do
  include_context "swt app"

  let(:real)   { double('real', disposed?: false).as_null_object }
  let(:dsl)    { double('dsl', app: shoes_app, visible?: true,
                        element_left: 100, element_top: 100,
                        element_width: 70, element_height: 10,
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
