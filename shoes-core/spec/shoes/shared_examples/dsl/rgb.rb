shared_examples_for "rgb DSL method" do
  let(:red) { 100 }
  let(:green) { 149 }
  let(:blue) { 237 }
  let(:alpha) { 133 } # cornflowerblue

  it "sends args to Shoes::Color" do
    expect(Shoes::Color).to receive(:new).with(red, green, blue, alpha)
    dsl.rgb(red, green, blue, alpha)
  end

  it "defaults to opaque" do
    expect(Shoes::Color).to receive(:new).with(red, green, blue, Shoes::Color::OPAQUE)
    dsl.rgb(red, green, blue)
  end

  describe "named color method" do
    it "produces correct color" do
      expect(dsl.cornflowerblue).to eq(Shoes::Color.new red, green, blue)
    end

    it "accepts alpha arg" do
      expect(dsl.cornflowerblue(alpha)).to eq(Shoes::Color.new red, green, blue, alpha)
    end
  end
end
