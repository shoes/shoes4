shared_examples_for "rgb DSL method" do
  let(:red) { 100 }
  let(:green) { 149 }
  let(:blue) { 237 }
  let(:alpha) { 133 } # cornflowerblue

  it "sends args to Shoes::Color" do
    Shoes::Color.should_receive(:new).with(red, green, blue, alpha)
    dsl.rgb(red, green, blue, alpha)
  end

  it "defaults to opaque" do
    Shoes::Color.should_receive(:new).with(red, green, blue, Shoes::Color::OPAQUE)
    dsl.rgb(red, green, blue)
  end

  describe "named color method" do
    it "produces correct color" do
      dsl.cornflowerblue.should eq(Shoes::Color.new red, green, blue)
    end

    it "accepts alpha arg" do
      dsl.cornflowerblue(alpha).should eq(Shoes::Color.new red, green, blue, alpha)
    end
  end
end
