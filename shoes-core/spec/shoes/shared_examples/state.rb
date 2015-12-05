shared_examples_for "object with state" do
  let(:input_opts) { {state: "disabled"} }

  it "should initialize" do
    expect(subject.state).to eq("disabled")
  end

  it "should enable" do
    expect(subject.gui).to receive(:enabled).with(true)
    subject.state = nil
    expect(subject.state).to eq(nil)
  end

  it "should disable" do
    expect(subject.gui).to receive(:enabled).with(false)
    subject.state = "disabled"
    expect(subject.state).to eq("disabled")
  end

  it "does not disable when a string other than disabled is passed" do
    expect(subject.gui).to receive(:enabled).with(true)
    subject.state = "enabled"
    expect(subject.state).to eq("enabled")
  end
end
