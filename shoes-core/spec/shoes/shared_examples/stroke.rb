shared_examples_for "object with stroke" do |default_color = :black|
  let(:color) { Shoes::COLORS.fetch :tomato }
  let(:color2) { Shoes::COLORS.fetch :forestgreen }
  let(:gradient) { Shoes::Gradient.new(color, color2) }

  it "updates gui" do
    expect(subject.gui).to receive(:update_stroke)
    subject.update_stroke
  end

  it "returns a color" do
    c = subject.stroke = color
    expect(c.class).to eq(Shoes::Color)
  end

  it "sets on receiver" do
    subject.stroke = color
    expect(subject.stroke).to eq(color)
    expect(subject.style[:stroke]).to eq(color)
  end

  it "sets with a gradient" do
    subject.stroke = gradient
    expect(subject.stroke).to eq(gradient)
    expect(subject.style[:stroke]).to eq(gradient)
  end

  # Be sure the subject does *not* have the stroke set previously
  it "defaults to #{default_color}" do
    expect(subject.stroke).to eq(Shoes::COLORS.fetch(default_color))
  end

  describe "strokewidth" do
    it "defaults to 1" do
      expect(subject.strokewidth).to eq(1)
    end

    it "sets" do
      subject.strokewidth = 2
      expect(subject.strokewidth).to eq(2)
    end
  end
end
