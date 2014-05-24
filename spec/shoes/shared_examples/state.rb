shared_examples_for "object with state" do
  let(:input_opts) { {:state => "disabled"} }

  it "should initialize" do
    expect(subject.state).to eq("disabled")
  end

  it "should enable" do
    subject.gui.should_receive(:enabled).with(true)
    subject.state = nil
    expect(subject.state).to eq(nil) 
  end

  it "should disable" do
    subject.gui.should_receive(:enabled).with(false)
    subject.state = "disabled"
    expect(subject.state).to eq("disabled")
  end
end