shared_examples_for "movable object" do
  it "moves" do
    subject.move(300, 200)
    subject.left.should eq(300)
    subject.top.should eq(200)
  end
end

