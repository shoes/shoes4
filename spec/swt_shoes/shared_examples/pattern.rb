shared_examples_for "an swt pattern" do
  it { is_expected.to respond_to(:apply_as_stroke) }
  it { is_expected.to respond_to(:apply_as_fill) }

  describe "#apply_as_stroke" do
    let(:gc) { double("graphics context") }
    let(:left) { 0 }
    let(:top) { 0 }
    let(:width) { 10 }
    let(:height) { 10 }

    it "sets foreground" do
      if subject.is_a? Shoes::Swt::Color
        allow(gc).to receive(:set_alpha)
        expect(gc).to receive(:set_foreground)
      else
        expect(gc).to receive(:set_foreground_pattern)
      end
      subject.apply_as_stroke(gc, left, top, width, height)
    end

    it "sets alpha" do
      if subject.is_a? Shoes::Swt::Color
        allow(gc).to receive(:set_foreground)
        expect(gc).to receive(:set_alpha)
      else
        expect(gc).to receive(:set_foreground_pattern)
      end
      subject.apply_as_stroke(gc, left, top, width, height)
    end
  end
end
