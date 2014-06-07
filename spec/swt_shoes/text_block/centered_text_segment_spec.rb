require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlock::CenteredTextSegment do
  let(:width) { 200 }
  let(:dsl)   { double("dsl", text: "boo", font: "", font_size: 16, opts:{}) }

  subject { Shoes::Swt::TextBlock::CenteredTextSegment.new(dsl, width)}

  it "takes all the width it can get" do
    expect(subject.width).to eq(width)
  end

  it "calls last line width the full width" do
    expect(subject.last_line_width).to eq(width)
  end
end
