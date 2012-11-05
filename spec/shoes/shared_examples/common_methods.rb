shared_examples_for "movable object" do
  it "moves" do
    subject.move(300, 200)
    subject.left.should eq(300)
    subject.top.should eq(200)
  end
end

shared_examples_for "movable object with gui" do
  it "tells gui to move" do
    subject.gui.should_receive(:move).with(300, 200)
    subject.move(300, 200)
  end
end

shared_examples_for "clearable object" do
  it "clears" do
    subject.should_receive(:clear)
    subject.clear
  end
end
