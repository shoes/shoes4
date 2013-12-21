require 'swt_shoes/spec_helper'

describe Shoes::Swt::InputBox do
  include_context "swt app"

  let(:dsl) { double('dsl', app: shoes_app, visible?: true, element_width: 80,
                            element_height: 22, initial_text: 'Jay',
                            secret?: secret).as_null_object }
  let(:real) { double('real', disposed?: false).as_null_object }
  let(:styles) {::Swt::SWT::SINGLE | ::Swt::SWT::BORDER}
  let(:secret) {false}

  subject { Shoes::Swt::InputBox.new dsl, parent, styles }

  before :each do
    ::Swt::Widgets::Text.stub(:new) { real }
    ::Swt::Widgets::Text.stub(:text=) { real }
  end

  it_behaves_like "movable element"
  it_behaves_like "clearable native element"
  it_behaves_like "togglable"

  describe "#initialize" do
    let(:event) {double 'Event', source: source}
    let(:source) {double 'Source'}
    it "sets text on real element" do
      subject.text = "some text"
      expect(real).to have_received(:text=).with("some text")
    end

    it "should set up a listener that delegates change events" do
      expect(dsl).to receive(:call_change_listeners)
      expect(real).to receive(:add_modify_listener) do |&blk|
        blk.call(event)
      end
      subject
    end
  end

  describe Shoes::Swt::EditLine do
    subject {Shoes::Swt::EditLine.new dsl, parent}
    describe ":secret option" do
      let(:secret) {true}
      it "sets PASSWORD style" do
        edit_box_password_style = ::Swt::SWT::SINGLE | ::Swt::SWT::BORDER | ::Swt::SWT::PASSWORD
        expect(::Swt::Widgets::Text).to receive(:new).with( parent.real,
                                                           edit_box_password_style)
        subject
      end
    end
  end
end
