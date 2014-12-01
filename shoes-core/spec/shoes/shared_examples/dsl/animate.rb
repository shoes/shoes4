shared_examples_for "animate DSL method" do
  context "defaults" do
    let(:animation) { dsl.animate {} }

    it "is a Shoes::Animation" do
      expect(animation).to be_an_instance_of(Shoes::Animation)
    end

    it "framerate is 10" do
      expect(animation.framerate).to eq 10
    end
  end

  context "with numeric argument" do
    let(:animation) { dsl.animate(13) {} }

    it "sets framerate" do
      expect(animation.framerate).to eq(13)
    end
  end

  context "with hash argument" do
    let(:animation) { dsl.animate(:framerate => 17) {} }

    it "sets framerate" do
      expect(animation.framerate).to eq(17)
    end
  end
end
