shared_examples_for "strokewidth DSL method" do
  it "returns a number" do
    expect(dsl.strokewidth(4)).to eq(4)
  end

  it "sets on receiver" do
    dsl.strokewidth 4
    expect(dsl.style[:strokewidth]).to eq(4)
  end

  it "applies to subsequently created objects" do
    dsl.strokewidth 6
    expect(Shoes::Oval).to receive(:new) do |*args|
      style = args.pop
      expect(style[:strokewidth]).to eq(6)
    end
    dsl.oval(10, 10, 100, 100)
  end
end
