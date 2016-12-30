shared_examples "object with rotate" do
  it "only rotates when necessary" do
    subject.rotate = nil
    expect(subject.needs_rotate?).to be_falsey
  end

  it "needs to rotate" do
    subject.rotate = 10
    expect(subject.needs_rotate?).to be_truthy
  end
end
