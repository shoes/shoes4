require 'swt_shoes/spec_helper'

describe Shoes::Swt::FittedTextLayout do
  let(:layout) { double("layout", text: "the text", set_style: nil) }
  let(:font)   { double("font") }
  let(:style)  { double("style") }

  let(:style_hash) {
    {
      bg: double("bg"),
      fg: double("fg"),
      font_detail: {
        name: "Comic Sans",
        size: 18,
        styles: nil
      }
    }
  }

  before(:each) do
    Shoes::Swt::TextFontFactory.stub(:create_font) { font }
    Shoes::Swt::TextStyleFactory.stub(:create_style) { style }
  end

  subject { Shoes::Swt::FittedTextLayout.new(layout, 0, 0) }

  it "should allow setting style on full range" do
    subject.set_style(style_hash)
    expect(layout).to have_received(:set_style).with(style, 0, layout.text.length - 1)
  end

  it "should allow setting style with a range" do
    subject.set_style(style_hash, 1..2)
    expect(layout).to have_received(:set_style).with(style, 1, 2)
  end
end
