shared_examples_for "pattern DSL method" do
  let(:honeydew) { Shoes::COLORS[:honeydew] }
  let(:salmon) { Shoes::COLORS[:salmon] }

  context "with single color" do
    let(:pattern) { dsl.pattern honeydew }
    it "returns the color" do
      expect(pattern).to eq(honeydew)
    end
  end

  context "with color range" do
    let(:pattern) { dsl.pattern honeydew..salmon }

    it "returns a gradient" do
      expect(pattern).to eq(dsl.gradient honeydew..salmon)
    end
  end

  context "with single string" do
    let(:pattern) { dsl.pattern honeydew.hex }
    it "returns the color" do
      expect(pattern).to eq(honeydew)
    end
  end

  context "with string range" do
    let(:pattern) { dsl.pattern honeydew.hex..salmon.hex }

    it "returns a gradient" do
      expect(pattern).to eq(dsl.gradient honeydew..salmon)
    end
  end
end
