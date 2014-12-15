require 'shoes/swt/spec_helper'

describe Shoes::Swt::ClickListener do
  include_context 'swt app'

  let(:dsl) { double('dsl') }
  let(:swt) { double('swt', dsl: dsl) }

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
      subject.add_click_listener(swt)
      expect(subject.clickable_elements).to eq([dsl])
    end

    it "adds a release listener" do
      subject.add_release_listener(swt)
      expect(subject.clickable_elements).to eq([dsl])
    end

    it "only reports each element once" do
      subject.add_click_listener(swt)
      subject.add_release_listener(swt)
      expect(subject.clickable_elements).to eq([dsl])
    end
  end
end
