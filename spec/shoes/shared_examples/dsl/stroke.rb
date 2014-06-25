shared_examples_for "stroke DSL method" do
  let(:color) { Shoes::COLORS.fetch :tomato }

  it "returns a color" do
    expect(dsl.stroke(color).class).to eq(Shoes::Color)
  end

  # This works differently on a container than on a normal element
  it "sets on receiver" do
    dsl.stroke color
    expect(dsl.style[:stroke]).to eq(color)
  end

  it "applies to subsequently created objects" do
    dsl.stroke color
    expect(Shoes::Rect).to receive(:new) do |*args|
      style = args[-2]
      expect(style[:stroke]).to eq(color)
    end
    dsl.rect(10, 10, 100, 100)
  end

  context "with hex string" do
    let(:color) { "#fff" }

    it "sets the color" do
      expect(dsl.stroke(color)).to eq(Shoes::COLORS[:white])
    end
  end
end
