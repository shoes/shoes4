# frozen_string_literal: true
shared_examples_for "object with fill" do |default_color = :black|
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
  specify "defaults to #{default_color}" do
    expect(subject.fill).to eq(Shoes::COLORS.fetch(default_color))
  end
end
