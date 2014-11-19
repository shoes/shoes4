require 'shoes/swt/spec_helper'

describe Shoes::Swt::InputBox do
  include_context "swt app"

  let(:dsl) { double('dsl', app: shoes_app, visible?: true, element_width: 80,
                            element_height: 22, initial_text: 'Jay',
                            secret?: secret,
                            call_change_listeners: true).as_null_object }
  let(:real) { double('real', disposed?: false, text: text,
                      add_modify_listener: true).as_null_object }
  let(:styles) {::Swt::SWT::SINGLE | ::Swt::SWT::BORDER}
  let(:secret) {false}
  let(:text) {'Some text...'}

  subject { Shoes::Swt::InputBox.new dsl, parent, styles }

  before :each do
    allow(::Swt::Widgets::Text).to receive(:new) { real }
    allow(::Swt::Widgets::Text).to receive(:text=) { real }
  end

  it_behaves_like "movable element"
  it_behaves_like "removable native element"
  it_behaves_like "updating visibility"

  describe "#initialize" do
    let(:event) {double 'Event', source: source}
    let(:source) {double 'Source'}
    it "sets text on real element" do
      subject.text = "some text"
      expect(real).to have_received(:text=).with("some text")
    end

    describe 'change listeners' do

      it "should set up a listener that delegates change events" do
        expect(dsl).to receive(:call_change_listeners)
        expect(real).to receive(:add_modify_listener) do |&blk|
          blk.call(event)
        end
        subject
      end

      describe 'modify block' do
        before :each do
          @modify_block = nil
          expect(real).to receive(:add_modify_listener) do |&blk|
            @modify_block = blk
          end
          subject
        end

        it 'normally calls the dsl change listeners' do
          @modify_block.call event

          expect(dsl).to have_received :call_change_listeners
        end

        describe 'with the same text' do
          let(:event) {double 'Bad Event', source: source}
          let(:source) {double 'Our source', text: text}
          let(:text) {'Double call'}

          it 'does not call the change listeners' do
            subject.text = text
            allow(event).to receive(:instance_of?) do |klazz|
              klazz == Java::OrgEclipseSwtEvents::ModifyEvent
            end
            allow(source).to receive(:instance_of?) do |klazz|
              klazz == Java::OrgEclipseSwtWidgets::Text
            end
            @modify_block.call event
            expect(dsl).to_not have_received :call_change_listeners
          end
        end

      end
    end
  end

  describe 'text selections' do
    it 'translates the highlight_text call' do
      subject.highlight_text 4, 20
      expect(real).to have_received(:set_selection).with(4, 20)
    end

    it 'translates the caret_to call' do
      subject.caret_to 42
      expect(real).to have_received(:set_selection).with(42)
    end
  end

  describe Shoes::Swt::EditLine do
    subject {Shoes::Swt::EditLine.new dsl, parent}
    describe ":secret option" do
      context "when NOT set" do
        it "does NOT set PASSWORD style" do
          options = Shoes::Swt::EditLine::DEFAULT_STYLES
          allow(dsl).to receive(:secret?) { false }
          expect(::Swt::Widgets::Text).to receive(:new).with(parent.real, options)
          subject
        end
      end

      context "when set" do
        it "sets PASSWORD style" do
          options = Shoes::Swt::EditLine::DEFAULT_STYLES | ::Swt::SWT::PASSWORD
          allow(dsl).to receive(:secret?) { true }
          expect(::Swt::Widgets::Text).to receive(:new).with(parent.real, options)
          subject
        end
      end
    end
  end
end
