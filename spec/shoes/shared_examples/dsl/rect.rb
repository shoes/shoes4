shared_examples_for "rectangle dimensions" do
  it "makes a Shoes::Rect" do
    rect.should be_an_instance_of(Shoes::Rect)
  end

  it "sets proper dimensions" do
    rect.left.should eq(left)
    rect.top.should eq(top)
    rect.width.should eq(width)
    rect.height.should eq(height)
  end
end

shared_examples_for "rect DSL method" do
  let(:left)   { 40 }
  let(:top)    { 30 }
  let(:curve)  { 12 }

  context 'unequal sides' do
    let(:width)  { 200 }
    let(:height) { 100 }

    context "from explicit arguments" do
      let(:rect) { dsl.rect left, top, width, height }

      include_examples "rectangle dimensions"

      it "defaults to corner radius of 0" do
        rect.corners.should eq(0)
      end
    end

    context "round corners, from explicit arguments" do
      let(:rect) { dsl.rect left, top, width, height, curve }

      include_examples "rectangle dimensions"

      it "sets corner radius" do
        rect.corners.should eq(curve)
      end
    end

    context "from style hash" do
      let(:rect) { dsl.rect left: left, top: top, width: width, height: height }

      include_examples "rectangle dimensions"

      it "defaults to corner radius of 0" do
        rect.corners.should eq(0)
      end
    end

    context "rounded corners, from style hash" do
      let(:rect) { dsl.rect left: left, top: top, width: width, height: height, curve: curve }

      include_examples "rectangle dimensions"

      it "sets corner radius" do
        rect.corners.should eq(curve)
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
        rect.corners.should eq(0)
      end
    end

    context "square, from style hash" do
      let(:rect) { dsl.rect left: left, top: top, width: width }

      include_examples "rectangle dimensions"

      it "defaults to corner radius of 0" do
        rect.corners.should eq(0)
      end
    end
  end
end
