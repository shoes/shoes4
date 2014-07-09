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
    expect(Shoes::Rect).to receive(:new) do |*args|
      style = args[-2]
      expect(style[:strokewidth]).to eq(6)
    end
    dsl.rect(10, 10, 100, 100)
  end
end
