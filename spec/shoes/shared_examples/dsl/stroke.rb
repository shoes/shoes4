shared_examples_for "stroke DSL method" do
  let(:color) { Shoes::COLORS.fetch :tomato }

  it "returns a color" do
    dsl.stroke(color).class.should eq(Shoes::Color)
  end

  # This works differently on a container than on a normal element
  it "sets on receiver" do
    dsl.stroke color
    dsl.style[:stroke].should eq(color)
  end

  it "applies to subsequently created objects" do
    dsl.stroke color
    Shoes::Oval.should_receive(:new).with do |*args|
      style = args.pop
      style[:stroke].should eq(color)
    end
    dsl.oval(10, 10, 100, 100)
  end

  context "with hex string" do
    let(:color) { "#fff" }

    it "sets the color" do
      dsl.stroke(color).should eq(Shoes::COLORS[:white])
    end
  end
end
