require 'shoes/swt/spec_helper'

describe Shoes::Swt::ClickListener do
  include_context 'swt app'

  let(:dsl) { double('dsl') }
  let(:swt) { double('swt', dsl: dsl) }

  subject   { Shoes::Swt::ClickListener.new }

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
