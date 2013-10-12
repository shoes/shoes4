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
