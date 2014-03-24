shared_examples_for "object with dimensions" do
  it "should initialize" do
    subject.left.should == left
    subject.top.should == top
    subject.width.should == width
    subject.height.should == height
  end
end

shared_examples_for "object with relative dimensions" do
  let(:relative_width) { 0.5 }
  let(:relative_height) { 0.5 }
  let(:relative_opts) { {left: left, top: top, width: relative_width, height: relative_height} }

  it "should initialize based on parent dimensions" do
    expect(subject.left).to eq left
    expect(subject.top).to eq top
    expect(subject.width).to be_within(1).of(parent.width / 2)
    expect(subject.height).to be_within(1).of(parent.height / 2)
  end
end

shared_examples_for "object with negative dimensions" do
  let(:negative_opts) { {left: left, top: top, width: -width, height: -height} }

  it "should initialize based on parent dimensions" do
    subject.left.should == left
    subject.top.should == top
    subject.width.should == parent.width - width
    subject.height.should == parent.height - height
  end
end
