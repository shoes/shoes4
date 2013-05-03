shared_examples_for "animate DSL method" do
  context "defaults" do
    let(:animation) { dsl.animate {} }

    it "is a Shoes::Animation" do
      animation.should be_an_instance_of(Shoes::Animation)
    end

    it "framerate is 10" do
      animation.framerate.should eq(10)
    end
  end

  context "with numeric argument" do
    let(:animation) { dsl.animate(13) {} }

    it "sets framerate" do
      animation.framerate.should eq(13)
    end
  end

  context "with hash argument" do
    let(:animation) { dsl.animate(:framerate => 17) {} }

    it "sets framerate" do
      animation.framerate.should eq(17)
    end
  end
end
