# Must pass the container object in the shared examples call.
#
#   it_behaves_like "dsl container", container_object
shared_examples "dsl container" do |container|
  describe "animate" do
    context "defaults" do
      let(:animation) { subject.animate {} }

      specify "is a Shoes::Animation" do
        animation.should be_an_instance_of(Shoes::Animation)
      end

      specify "framerate is 24" do
        animation.framerate.should eq(24)
      end
    end

    context "with numeric argument" do
      let(:animation) { subject.animate(13) {} }

      specify "sets framerate" do
        animation.framerate.should eq(13)
      end
    end

    context "with hash argument" do
      let(:animation) { subject.animate(:framerate => 17) {} }

      specify "sets framerate" do
        animation.framerate.should eq(17)
      end
    end
  end
end
