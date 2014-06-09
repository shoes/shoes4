shared_examples_for "an oval/circle element" do
  it "makes a Shoes::Oval" do
    expect(oval).to be_instance_of(Shoes::Oval)
  end

  it "sets the proper dimensions" do
    expect(oval.top).to eq(top)
    expect(oval.left).to eq(left)
    expect(oval.width).to eq(width)
    expect(oval.height).to eq(height)
  end

  it "sets stroke" do
    expect(oval.style[:stroke]).to eq(stroke)
  end

  it "sets fill" do
    expect(oval.style[:fill]).to eq(fill)
  end
end

shared_examples_for "oval DSL method" do
  let(:left)   { 20 }
  let(:top)    { 30 }
  let(:width)  { 100 }
  let(:height) { 200 }
  let(:stroke) { Shoes::COLORS[:black] }
  let(:fill) { Shoes::COLORS[:black] }

  describe "creating an oval" do
    describe "with explicit arguments" do
      let(:oval) { dsl.oval(left, top, width, height) }
      it_behaves_like "an oval/circle element"
    end

    describe "with stroke and fill styles" do
      let(:stroke) { Shoes::COLORS.fetch :orchid }
      let(:fill) { Shoes::COLORS.fetch :lemonchiffon }

      describe "as colors" do
        let(:oval) { dsl.oval(left, top, width, height, stroke: stroke, fill: fill) }
        it_behaves_like "an oval/circle element"
      end

      describe "as hex strings" do
        let(:oval) { dsl.oval(left, top, width, height, stroke: stroke.hex, fill: fill.hex) }
        it_behaves_like "an oval/circle element"
      end
    end

    describe "with too few arguments" do
      it "raises an ArgumentError" do
        expect { dsl.oval(10) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "creating a circle" do
    let(:width) { height }

    describe "with explicit arguments" do
      let(:oval) { dsl.oval(left, top, width, height) }
      it_behaves_like "an oval/circle element"
    end

    describe "with top, left, diameter" do
      let(:oval) { dsl.oval(left, top, width) }
      it_behaves_like "an oval/circle element"
    end

    describe "with a style hash" do
      describe "containing left, top, height, width" do
        let(:oval) { dsl.oval(left: left, top: top, width: width, height: height) }
        it_behaves_like "an oval/circle element"
      end

      describe "containing left, top, height, width, center: false" do
        let(:oval) { dsl.oval(left: left, top: top, width: width, height: height, center: false) }
        it_behaves_like "an oval/circle element"
      end

      describe "containing left, top, diameter" do
        let(:oval) { dsl.oval(left: left, top: top, diameter: width) }
        it_behaves_like "an oval/circle element"
      end
    end
  end
end
