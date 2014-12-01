shared_examples_for "rectangle dimensions" do
  it "makes a Shoes::Rect" do
    expect(rect).to be_an_instance_of(Shoes::Rect)
  end

  it "sets proper dimensions" do
    expect(rect.left).to eq(left)
    expect(rect.top).to eq(top)
    expect(rect.width).to eq(width)
    expect(rect.height).to eq(height)
  end
end

shared_examples_for "rect DSL method" do
  let(:left)   { 40 }
  let(:top)    { 30 }
  let(:curve)  { 12 }

  it "raises an ArgumentError" do
    expect { dsl.rect(30) }.to raise_exception(ArgumentError)
  end

  context 'unequal sides' do
    let(:width)  { 200 }
    let(:height) { 100 }

    context "from explicit arguments" do
      let(:rect) { dsl.rect left, top, width, height }

      include_examples "rectangle dimensions"

      it "defaults to corner radius of 0" do
        expect(rect.curve).to eq(0)
      end
    end

    context "round corners, from explicit arguments" do
      let(:rect) { dsl.rect left, top, width, height, curve }

      include_examples "rectangle dimensions"

      it "sets corner radius" do
        expect(rect.curve).to eq(curve)
      end
    end

    context "from style hash" do
      let(:rect) { dsl.rect left: left, top: top, width: width, height: height }

      include_examples "rectangle dimensions"

      it "defaults to corner radius of 0" do
        expect(rect.curve).to eq(0)
      end
    end

    context "rounded corners, from style hash" do
      let(:rect) { dsl.rect left: left, top: top, width: width, height: height, curve: curve }

      include_examples "rectangle dimensions"

      it "sets corner radius" do
        expect(rect.curve).to eq(curve)
      end
    end
  end

  context "square" do
    let(:width)  { 200 }
    let(:height) { 200 }

    context "from explicit arguments" do
      let(:rect) { dsl.rect left, top, width }

      include_examples "rectangle dimensions"

      it "defaults to corner radius of 0" do
        expect(rect.curve).to eq(0)
      end
    end

    context "square, from style hash" do
      let(:rect) { dsl.rect left: left, top: top, width: width }

      include_examples "rectangle dimensions"

      it "defaults to corner radius of 0" do
        expect(rect.curve).to eq(0)
      end
    end
  end
end
