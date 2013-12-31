shared_examples_for "movable object" do
  it "moves" do
    subject.instance_variable_set(:@app, app)
    subject.move(300, 200).should eq(subject)
    subject.left.should eq(300)
    subject.top.should eq(200)
  end
end

shared_examples_for "clearable object" do
  it "clears" do
    subject.should_receive(:clear)
    subject.clear
  end
end

shared_examples_for "left, top as center" do | *params |
  let(:centered_object) { described_class.new(app, parent, left, top, width, height, *params, :center => true) }
  it "should now be located somewhere" do
    centered_object.left.should eq(left-(width/2))
    centered_object.top.should eq(top-(height/2))
    centered_object.right.should eq(left-(width/2)+width-1)
    centered_object.bottom.should eq(top-(height/2)+height-1)
    centered_object.width.should eq(width)
    centered_object.height.should eq(height)
  end
end
