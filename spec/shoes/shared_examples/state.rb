shared_examples_for "object with state" do
  let(:input_opts) { {:state => "disabled"} }

  it "should initialize" do
    subject.state.should == "disabled"
  end

  it "should enable" do
    subject.gui.should_receive(:enabled).with(true)
    subject.state = nil
    subject.state.should == nil 
  end

  it "should disable" do
    subject.gui.should_receive(:enabled).with(false)
    subject.state = "disabled"
    subject.state.should == "disabled"
  end
end