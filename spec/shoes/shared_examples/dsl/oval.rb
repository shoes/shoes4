shared_examples_for "an oval/circle element" do
  it "makes a Shoes::Oval" do
    oval.should be_instance_of(Shoes::Oval)
  end

  it "sets the proper dimensions" do
    oval.top.should eq(top)
    oval.left.should eq(left)
    oval.width.should eq(width)
    oval.height.should eq(height)
  end
end

shared_examples_for "oval DSL method" do
  let(:left)   { 20 }
  let(:top)    { 30 }
  let(:width)  { 100 }
  let(:height) { 200 }

  let(:oval) { dsl.oval(left, top, width, height) }

  context "eccentric, from explicit arguments" do
    it_behaves_like "an oval/circle element"
  end

  context "a circle" do
    let(:width) { height }

    describe "when constructed from explicit arguments" do
      it_behaves_like "an oval/circle element"
    end

    describe "when constructed with a top, left and diameter" do
      let(:circle) { dsl.oval(left, top, width) }
      it_behaves_like "an oval/circle element"
    end

    describe "when constructing from a style hash" do
      describe "using left, top, height, width" do
        let(:circle) { dsl.oval(left: left, top: top, width: width, height: height) }
        it_behaves_like "an oval/circle element"
      end

      describe "using left, top, height, width, center: false" do
        let(:circle) { dsl.oval(left: left, top: top, width: width, height: height, center: false) }
        it_behaves_like "an oval/circle element"
      end

      describe "using left, top, diameter" do
        let(:circle) { dsl.oval(left: left, top: top, diameter: width) }
        it_behaves_like "an oval/circle element"
      end
    end
  end

end
