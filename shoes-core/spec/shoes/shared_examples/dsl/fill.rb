shared_examples_for "fill DSL method" do
  let(:color) { Shoes::COLORS.fetch :tomato }

  it "returns a color" do
    expect(dsl.fill(color).class).to eq(Shoes::Color)
  end

  # This works differently on a container than on a normal element
  it "sets on receiver" do
    dsl.fill color
    expect(dsl.style[:fill]).to eq(color)
  end

  it "applies to subsequently created objects" do
    dsl.fill color
    oval = dsl.oval(10, 10, 100, 100)
    expect(oval.fill).to eq(color)
  end

  context "with hex string" do
    let(:color) { "#fff" }

    it "sets the color" do
      expect(dsl.fill(color)).to eq(Shoes::COLORS[:white])
    end
  end
end
