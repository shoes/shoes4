shared_examples_for "object with dimensions" do
  it "should initialize" do
    expect(subject.left).to eq(left)
    expect(subject.top).to eq(top)
    expect(subject.width).to eq(width)
    expect(subject.height).to eq(height)
  end
end

shared_examples_for "object with relative dimensions" do
  let(:relative_width) { 0.5 }
  let(:relative_height) { 0.5 }
  let(:relative_opts) { {left: left, top: top, width: relative_width, height: relative_height} }

  it "should initialize based on parent dimensions" do
    expect(subject.left).to eq left
    expect(subject.top).to eq top
    expect(subject.width).to be_within(1).of(parent.element_width / 2)
    expect(subject.height).to be_within(1).of(parent.element_height / 2)
  end
end

shared_examples_for "object with negative dimensions" do
  let(:negative_opts) { {left: left, top: top, width: -width, height: -height} }

  it "should initialize based on parent dimensions" do
    expect(subject.left).to eq(left)
    expect(subject.top).to eq(top)
    expect(subject.width).to eq(parent.element_width - width)
    expect(subject.height).to eq(parent.element_height - height)
  end
end
