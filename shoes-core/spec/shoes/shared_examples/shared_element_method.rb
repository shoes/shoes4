require 'shoes/color'

shared_examples_for "object with stroke" do
  let(:color) { Shoes::COLORS.fetch :tomato }
  let(:color2) { Shoes::COLORS.fetch :forestgreen }
  let(:gradient) { Shoes::Gradient.new(color, color2) }

  specify "returns a color" do
    c = subject.stroke = color
    expect(c.class).to eq(Shoes::Color)
  end

  specify "sets on receiver" do
    subject.stroke = color
    expect(subject.stroke).to eq(color)
    expect(subject.style[:stroke]).to eq(color)
  end

  specify "sets with a gradient" do
    subject.stroke = gradient
    expect(subject.stroke).to eq(gradient)
    expect(subject.style[:stroke]).to eq(gradient)
  end

  # Be sure the subject does *not* have the stroke set previously
  specify "defaults to black" do
    expect(subject.stroke).to eq(Shoes::COLORS.fetch :black)
  end

  describe "strokewidth" do
    specify "defaults to 1" do
      expect(subject.strokewidth).to eq(1)
    end

    specify "sets" do
      subject.strokewidth = 2
      expect(subject.strokewidth).to eq(2)
    end
  end
end

shared_examples_for "object with fill" do
  let(:color) { Shoes::COLORS.fetch :honeydew }

  specify "returns a color" do
    c = subject.fill = color
    expect(c.class).to eq(Shoes::Color)
  end

  specify "sets on receiver" do
    subject.fill = color
    expect(subject.fill).to eq(color)
    expect(subject.style[:fill]).to eq(color)
  end

  # Be sure the subject does *not* have the stroke set previously
  specify "defaults to black" do
    expect(subject.fill).to eq(Shoes::COLORS.fetch :black)
  end
end
