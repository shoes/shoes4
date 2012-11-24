shared_examples_for "an swt pattern" do
  it { should respond_to(:apply_as_stroke) }
  it { should respond_to(:apply_as_fill) }

  describe "#apply_as_stroke" do
    let(:gc) { double("graphics context") }

    it "sets foreground" do
      gc.stub(:set_alpha)
      gc.should_receive(:set_foreground)
      subject.apply_as_stroke(gc)
    end

    it "sets alpha" do
      gc.stub(:set_foreground)
      gc.should_receive(:set_alpha)
      subject.apply_as_stroke(gc)
    end
  end

  describe "#apply_as_fill" do
    let(:gc) { double("graphics context") }

    it "sets background" do
      gc.stub(:set_alpha)
      gc.stub(:set_foreground)
      gc.should_receive(:set_background)
      subject.apply_as_fill(gc)
    end

    it "sets foreground" do
      gc.stub(:set_alpha)
      gc.stub(:set_background)
      gc.should_receive(:set_foreground)
      subject.apply_as_fill(gc)
    end

    it "sets alpha" do
      gc.stub(:set_background)
      gc.stub(:set_foreground)
      gc.should_receive(:set_alpha)
      subject.apply_as_fill(gc)
    end
  end
end
