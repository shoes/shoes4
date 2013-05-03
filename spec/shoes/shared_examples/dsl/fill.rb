shared_examples_for "fill DSL method" do
  let(:color) { Shoes::COLORS.fetch :tomato }

  it "returns a color" do
    dsl.fill(color).class.should eq(Shoes::Color)
  end

  # This works differently on a container than on a normal element
  it "sets on receiver" do
    dsl.fill color
    dsl.style[:fill].should eq(color)
  end

  it "applies to subsequently created objects" do
    dsl.fill color
    oval = dsl.oval(10, 10, 100, 100)
    oval.fill.should eq(color)
  end

  context "with hex string" do
    let(:color) { "#fff" }

    it "sets the color" do
      dsl.fill(color).should eq(Shoes::COLORS[:white])
    end
  end
end
