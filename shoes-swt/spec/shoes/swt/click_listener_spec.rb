require 'shoes/swt/spec_helper'

describe Shoes::Swt::ClickListener do
  include_context 'swt app'

  let(:dsl) { double('dsl', hidden?: false, pass_coordinates?: false) }

  let(:click_block)   { double("click block", call: nil) }
  let(:release_block) { double("release block", call: nil) }

  subject   { Shoes::Swt::ClickListener.new(swt_app) }

  before do
    allow(swt_app).to receive(:add_listener)
  end

  describe "SWT event wireup" do
    it "registers mouse down and mouse up" do
      subject
      expect(swt_app).to have_received(:add_listener).with(::Swt::SWT::MouseDown, subject)
      expect(swt_app).to have_received(:add_listener).with(::Swt::SWT::MouseUp, subject)
    end
  end

  describe "adding listeners" do
    it "adds a click listener" do
      subject.add_click_listener(dsl, click_block)
      expect(subject.clickable_elements).to eq([dsl])
    end

    it "adds a release listener" do
      subject.add_release_listener(dsl, release_block)
      expect(subject.clickable_elements).to eq([dsl])
    end

    it "only reports each element once" do
      subject.add_click_listener(dsl, click_block)
      subject.add_release_listener(dsl, release_block)
      expect(subject.clickable_elements).to eq([dsl])
    end
  end

  describe "removing" do
    it "removes safely when not added" do
      subject.remove_listeners_for(dsl)
      expect(subject.clickable_elements).to be_empty
    end

    it "removes element" do
      subject.add_click_listener(dsl, click_block)
      subject.add_release_listener(dsl, release_block)

      subject.remove_listeners_for(dsl)

      expect(subject.clickable_elements).to be_empty
    end
  end

  describe "event handling" do
    before do
      subject.add_click_listener(dsl, click_block)
      subject.add_release_listener(dsl, release_block)

      allow(dsl).to receive(:in_bounds?) { false }
      allow(dsl).to receive(:in_bounds?).with(10, 10) { true }
    end

    shared_examples_for "mouse event" do
      it "triggers" do
        event = double(type: event_type, x: 10, y: 10)
        subject.handle_event(event)

        expect(block).to have_received(:call)
      end

      it "doesn't trigger other block" do
        event = double(type: event_type, x: 10, y: 10)
        subject.handle_event(event)

        expect(other_block).to_not have_received(:call)
      end

      it "doesn't trigger click out of bounds" do
        event = double(type: event_type, x: 20, y: 10)
        subject.handle_event(event)

        expect(block).to_not have_received(:call)
      end

      it "re-registering an element's click overwrites old one" do
        another_block = double("another block", call: nil)
        subject.send(add_method, dsl, another_block)

        event = double(type: event_type, x: 10, y: 10)
        subject.handle_event(event)

        expect(block).to_not     have_received(:call)
        expect(another_block).to have_received(:call)
      end

      it "takes the last element to respond" do
        other_dsl = double("other dsl", in_bounds?: true,
                           hidden?: false, pass_coordinates?: false)
        other_block = double("other block", call: nil)

        subject.send(add_method, other_dsl, other_block)

        event = double(type: event_type, x: 10, y: 10)
        subject.handle_event(event)

        expect(block).to_not   have_received(:call)
        expect(other_block).to have_received(:call)
      end

      it "won't call on hidden elements" do
        allow(dsl).to receive(:hidden?) { true }

        event = double(type: event_type, x: 10, y: 10)
        subject.handle_event(event)

        expect(block).to_not have_received(:call)
      end

      it "passes dsl along by default to event" do
        event = double(type: event_type, x: 10, y: 10)
        subject.handle_event(event)

        expect(block).to have_received(:call).with(dsl)
      end

      it "can pass coordinates if requested" do
        allow(dsl).to receive(:pass_coordinates?) { true }

        event = double(type: event_type, x: 10, y: 10, button: 1)
        subject.handle_event(event)

        expect(block).to have_received(:call).with(1, 10, 10)
      end

      it "ignores incorrect event types" do
        event = double(type: ::Swt::SWT::KeyDown, x: 10, y: 10)
        subject.handle_event(event)

        expect(block).to_not have_received(:call)
      end
    end

    it_behaves_like "mouse event" do
      let(:event_type)  { ::Swt::SWT::MouseDown }
      let(:block)       { click_block }
      let(:other_block) { release_block }
      let(:add_method)  { :add_click_listener }
    end

    it_behaves_like "mouse event" do
      let(:event_type)  { ::Swt::SWT::MouseUp }
      let(:block)       { release_block }
      let(:other_block) { click_block }
      let(:add_method)  { :add_release_listener }
    end
  end
end
