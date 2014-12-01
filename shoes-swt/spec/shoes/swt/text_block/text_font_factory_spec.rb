require 'shoes/swt/spec_helper'

describe Shoes::Swt::TextFontFactory do
  let(:font_details) {
    {
      :name   => "Helvetica",
      :size   => 16,
      :styles => [::Swt::SWT::BOLD]
    }
  }

  subject { Shoes::Swt::TextFontFactory.new() }

  it "creates a font" do
    font = subject.create_font(font_details)
    expect(font).not_to be(nil)
  end

  it "disposes of fonts" do
    font = subject.create_font(font_details)
    expect(font).to receive(:dispose)

    subject.dispose
  end

  it "doesn't dispose already disposed fonts" do
    font = subject.create_font(font_details)
    font.dispose

    expect(font).not_to receive(:dispose)
    subject.dispose
  end

  it "reuses font instances" do
    font1 = subject.create_font(font_details)
    font2 = subject.create_font(font_details)

    expect(font1).to be(font2)
  end
end
