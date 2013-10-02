shared_examples_for "movable object" do
  it "moves" do
    subject.instance_variable_set(:@app, app)
    subject.move(300, 200).should eq(subject)
    subject.left.should eq(300)
    subject.top.should eq(200)
  end
end

shared_examples_for "movable object with gui" do
  it "tells gui to move" do
    subject.gui.should_receive(:move).with(300, 200)
    subject.instance_variable_set(:@app, app)
    subject.move(300, 200)
  end
end

shared_examples_for "clearable object" do
  it "clears" do
    subject.should_receive(:clear)
    subject.clear
  end
end

shared_examples_for "left, top as center" do | *params |
  let(:centered_object) { described_class.new(app, 100, 50, 40, 20, *params, :center => true) }
  it "should now be located somewhere" do
    centered_object.left.should eq(80)
    centered_object.top.should eq(40)
    centered_object.right.should eq(120)
    centered_object.bottom.should eq(60)
    centered_object.width.should eq(40)
    centered_object.height.should eq(20)
  end
end
