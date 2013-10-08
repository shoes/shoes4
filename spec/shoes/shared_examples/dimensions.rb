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

  it "should initialize" do
    subject.left.should == left
    subject.top.should == top
    subject.width.should == parent.width / 2
    subject.height.should == parent.height / 2
  end
end
